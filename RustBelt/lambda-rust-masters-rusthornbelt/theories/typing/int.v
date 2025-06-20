From lrust.typing Require Export type.
From lrust.typing Require Import bool programs.
Set Default Proof Using "Type".
Open Scope Z_scope.

Section int.
  Context `{!typeG Σ}.

  Program Definition int: type Zₛ :=
    {| pt_size := 1;  pt_own (z: Zₛ) _ vl := ⌜vl = [ #z]⌝; |}%I.
  Next Obligation. move=> *. by iIntros (->). Qed.

  Global Instance int_send: Send int.
  Proof. done. Qed.

  Lemma int_resolve E L : resolve E L int (const True).
  Proof. apply resolve_just. Qed.

  Lemma bool_ty_to_int E L : subtype E L bool_ty int Z_of_bool.
  Proof.
    apply subtype_plain_type. iIntros "*_!>_/=". iSplit; [done|].
    iSplit; [iApply lft_incl_refl|]. by iIntros.
  Qed.

  Lemma type_int_instr (z: Z) : typed_val #z int z.
  Proof.
    iIntros (?????) "_ _ _ _ _ $$ _ Obs". iMod persistent_time_receipt_0 as "⧖".
    iApply wp_value. iExists -[const z]. iFrame "Obs". iSplit; [|done].
    rewrite tctx_hasty_val'; [|done]. iExists 0%nat. iFrame "⧖". by iExists z.
  Qed.

  Lemma type_int {𝔄l 𝔅} (z: Z) (T: tctx 𝔄l) x e tr E L (C: cctx 𝔅) :
    Closed (x :b: []) e →
    (∀v: val, typed_body E L C (v ◁ int +:: T) (subst' x v e) tr) -∗
    typed_body E L C T (let: x := #z in e) (λ post al, tr post (z -:: al)).
  Proof. iIntros. iApply type_let; [apply type_int_instr|solve_typing|done..]. Qed.

  Lemma type_plus_instr E L p1 p2 :

    typed_instr_ty E L      (*E(external), L(local) : Lifetime contexts*)
      +[p1 ◁ int; p2 ◁ int] (*p ◁ ty (p: path typed ty)*)
      (p1 + p2)             (*e  : expr*)
      int                   (*ty': e を実行した後の型*)    
      (λ post '-[z; z'], post (z + z')).  (*tr : predicate transformer*)

      (* int : type Zₛ (semantic Rust type for integer)*)
      (* p1 + p2 : notation for addition in the λRust core calculus *)
      (* 
          predicate transformer :
          引数 
            事後条件 post : Z -> Prop, 値 z, z' : Z
          返り値 (Weakest precondition = 事後条件を満たすのに必要な条件)
            post (z + z') : Prop
          
          post : Continuation-Passing Style (命令実行後の処理を隠している)
      *)
  Proof.
    (* iIntros (??(?&?&[])) "_ _ _ _ _ $$ (P1 & P2 &_) Obs". *) 
    (* Walkthrough と異なる。次の2行をおそらく省略して書けるのだろう...*)

    (* suffix π : clairvoyant(透視的) values*)
    (* proph A : Type  透視的な reader monad のようなもの*)

    (* tid : thread id / postπ : proph ( *[Z] → Prop) *)
    (* zπ & zπ' &[] :  *[proph Z; proph Z] (透視的入力値リスト)*)
    intros tid postπ (zπ & zπ' &[]).

    (* Iris Proof Mode *)
    (* -* : magic wand の左辺を intros する*)
    (*
      contexts, elctx_interp E は ignore
      (resourses) na_own tid T と llctx_interp L 1 は WP 事後条件に pass したい
        -> "$" で frame out
      Obs : 事前条件 prophecy(予想) observation 
    *)
    iIntros "_ _ _ _ _ $ $ (P1 & P2 &_) Obs".
  
    (* P1 : Iris-level hypotheses*)
    (* wp_hasty 補題と sourse P1 により p1 を実行 
       p1 -> v1
    *)
    wp_apply (wp_hasty with "P1"). 

    (* The integer object has the pointer-nesting depth d1: nat, 
    and so we get a time receipt ⧖d1 for it. *)
    iIntros (v1 d1 _) "⧖". 

    (* 所有権述語 int.(ty_own) zπ d1 tid [v1]
      ⌜∃ z: Z, zπ = const z ∧ [v] = [#z]⌝
      デストラクトして
      z: Z
      rewrite zπ into const z
      rewrite v into #z
    *)
    iIntros ([z [-> [=->]]]).

    (* P2 についても同様 *)
    wp_apply (wp_hasty with "P2"). 
    iIntros (v2 d2 _) "_". iIntros ([z' [-> [=->]]]).

    (* 加算を実行 *)
    wp_op. 

    (* set zπl' to -[const (z + z')] *)
    iExists -[const (z + z')]. 

    (* the postcondition prophecy observation が Obs と一致*)
    iFrame "Obs". 
    (* *True の除去 *)
    iSplit; [|done].

    (* ? *)
    rewrite tctx_hasty_val'; [|done]. 

    (* set d to d1 *)
    iExists d1. 
    (* frame out ⧖d1 *)
    iFrame "⧖". 

    (* 
      Now the goal is just ty_own int ..., 
      which is unfolded into an existential quantification 
      over the Coq integer as we observed before.
      set the integer to z + z' and finish the remaining goal 
    *)
    by iExists (z + z').
  Qed.

  (* 3変数に対する加算 *)
  Lemma type_plus3_instr E L p1 p2 p3 :
  typed_instr_ty E L
    +[p1 ◁ int; p2 ◁ int; p3 ◁ int]
    (p1 + p2 + p3)
    int
    (λ post '-[z; z'; z''], post (z + z' + z'')).
  Proof.
    intros tid postπ (zπ & zπ' & zπ'' & []).
    iIntros "_ _ _ _ _ $ $ (P1 & P2 & P3 & _) Obs".

    wp_apply (wp_hasty with "P1").
    iIntros (v1 d1 _) "⧖". 
    iIntros ([z [-> [=->]]]).

    wp_apply (wp_hasty with "P2").
    iIntros (v2 d2 _) "_". 
    iIntros ([z' [-> [=->]]]).

    wp_op. 

    wp_apply (wp_hasty with "P3").
    iIntros (v3 d3 _) "_". 
    iIntros ([z'' [-> [=->]]]).

    wp_op.

    iExists -[const (z + z' + z'')].

    iFrame "Obs".

    iSplit; [|done].

    rewrite tctx_hasty_val'; [|done].

    iExists d1.
    iFrame "⧖".

    by iExists (z + z' + z'').
  Qed.

  Lemma type_plus {𝔄l 𝔅l ℭ} p1 p2 x e trx tr E L (C: cctx ℭ) (T: tctx 𝔄l) (T': tctx 𝔅l) :
    Closed (x :b: []) e → tctx_extract_ctx E L +[p1 ◁ int; p2 ◁ int] T T' trx →
    (∀v: val, typed_body E L C (v ◁ int +:: T') (subst' x v e) tr) -∗
    typed_body E L C T (let: x := p1 + p2 in e)
      (trx ∘ (λ post '(z -:: z' -:: bl), tr post (z + z' -:: bl))).
  Proof.
    iIntros (? Extr) "?". iApply type_let; [by apply type_plus_instr|solve_typing| |done].
    destruct Extr as [Htrx _]=>?? /=. apply Htrx. by case=> [?[??]].
  Qed.

  Lemma type_minus_instr E L p1 p2 :
    typed_instr_ty E L +[p1 ◁ int; p2 ◁ int] (p1 - p2) int
      (λ post '-[z; z'], post (z - z')).
  Proof.
    iIntros (??(?&?&[])) "_ _ _ _ _ $$ (p1 & p2 &_) Obs".
    wp_apply (wp_hasty with "p1"). iIntros "% %d _ ⧖" ((z &->&[=->])).
    wp_apply (wp_hasty with "p2"). iIntros "%% _ _" ((z' &->&[=->])).
    wp_op. iExists -[const (z - z')]. iFrame "Obs". rewrite right_id
    tctx_hasty_val'; [|done]. iExists d. iFrame "⧖". by iExists (z - z').
  Qed.

  Lemma type_minus {𝔄l 𝔅l ℭ} p1 p2 x e trx tr E L (C: cctx ℭ) (T: tctx 𝔄l) (T': tctx 𝔅l) :
    Closed (x :b: []) e → tctx_extract_ctx E L +[p1 ◁ int; p2 ◁ int] T T' trx →
    (∀v: val, typed_body E L C (v ◁ int +:: T') (subst' x v e) tr) -∗
    typed_body E L C T (let: x := p1 - p2 in e)
      (trx ∘ (λ post '(z -:: z' -:: bl), tr post (z - z' -:: bl))).
  Proof.
    iIntros (? Extr) "?". iApply type_let; [by apply type_minus_instr|solve_typing| |done].
    destruct Extr as [Htrx _]=>?? /=. apply Htrx. by case=> [?[??]].
  Qed.

  Lemma type_mult_instr E L p1 p2 :
    typed_instr_ty E L +[p1 ◁ int; p2 ◁ int] (p1 * p2) int
      (λ post '-[z; z'], post (z * z')).
  Proof.
    iIntros (??(?&?&[])) "_ _ _ _ _ $$ (p1 & p2 &_) Obs".
    wp_apply (wp_hasty with "p1"). iIntros "% %d _ ⧖" ((z &->&[=->])).
    wp_apply (wp_hasty with "p2"). iIntros "%% _ _" ((z' &->&[=->])).
    wp_op. iExists -[const (z * z')]. iFrame "Obs". rewrite right_id
    tctx_hasty_val'; [|done]. iExists d. iFrame "⧖". by iExists (z * z').
  Qed.

  Lemma type_mult {𝔄l 𝔅l ℭ} p1 p2 x e trx tr E L (C: cctx ℭ) (T: tctx 𝔄l) (T': tctx 𝔅l) :
    Closed (x :b: []) e → tctx_extract_ctx E L +[p1 ◁ int; p2 ◁ int] T T' trx →
    (∀v: val, typed_body E L C (v ◁ int +:: T') (subst' x v e) tr) -∗
    typed_body E L C T (let: x := p1 * p2 in e)
      (trx ∘ (λ post '(z -:: z' -:: bl), tr post (z * z' -:: bl))).
  Proof.
    iIntros (? Extr) "?". iApply type_let; [by apply type_mult_instr|solve_typing| |done].
    destruct Extr as [Htrx _]=>?? /=. apply Htrx. by case=> [?[??]].
  Qed.

  Lemma type_le_instr E L p1 p2 :
    typed_instr_ty E L +[p1 ◁ int; p2 ◁ int] (p1 ≤ p2) bool_ty
      (λ post '-[z; z'], post (bool_decide (z ≤ z'))).
  Proof.
    iIntros (??(?&?&[])) "_ _ _ _ _ $$ (p1 & p2 &_) Obs".
    wp_apply (wp_hasty with "p1"). iIntros "% %d _ ⧖" ((z &->&[=->])).
    wp_apply (wp_hasty with "p2"). iIntros "%% _ _" ((z' &->&[=->])).
    wp_op. iExists -[const (bool_decide (z ≤ z'))]. iFrame "Obs".
    rewrite right_id tctx_hasty_val'; [|done]. iExists d.
    iFrame "⧖". by iExists (bool_decide (z ≤ z')).
  Qed.

  Lemma type_le {𝔄l 𝔅l ℭ} p1 p2 x e trx tr E L (C: cctx ℭ) (T: tctx 𝔄l) (T': tctx 𝔅l) :
    Closed (x :b: []) e → tctx_extract_ctx E L +[p1 ◁ int; p2 ◁ int] T T' trx →
    (∀v: val, typed_body E L C (v ◁ bool_ty +:: T') (subst' x v e) tr) -∗
    typed_body E L C T (let: x := p1 ≤ p2 in e)
      (trx ∘ (λ post '(z -:: z' -:: bl), tr post (bool_decide (z ≤ z') -:: bl))).
  Proof.
    iIntros (? Extr) "?". iApply type_let; [by apply type_le_instr|solve_typing| |done].
    destruct Extr as [Htrx _]=>?? /=. apply Htrx. by case=> [?[??]].
  Qed.

  Lemma type_nd_int_instr E L :
    typed_instr_ty E L +[] NdInt int (λ post '-[], ∀z, post z).
  Proof.
    iIntros (???) "_ _ _ _ _ $$ _ #?". iMod persistent_time_receipt_0 as "⧖".
    wp_nd_int z. iExists -[const _]. rewrite right_id tctx_hasty_val'; [|done].
    iSplit. { iExists _. iFrame "⧖". by iExists _. }
    by iApply proph_obs_impl; [|done]=>/= ??.
  Qed.

  Lemma type_nd_int {𝔄l 𝔅} x e tr E L (C: cctx 𝔅) (T: tctx 𝔄l) :
    Closed (x :b: []) e →
    (∀v: val, typed_body E L C (v ◁ int +:: T) (subst' x v e) tr) -∗
    typed_body E L C T (let: x := NdInt in e)
      (λ post bl, ∀z, tr post (z -:: bl))%type.
  Proof.
    iIntros. by iApply type_let; [apply type_nd_int_instr|solve_typing| |done].
  Qed.


End int.

Global Hint Resolve int_resolve : lrust_typing.
