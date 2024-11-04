fn main() {
    let an_integer = 1u32;
    let a_boolean = true;
    let unit = ();

    // copy `an_integer` into `copied_integer`
    // `an_integer`を`copied_integer`へとコピー
    let copied_integer = an_integer;

    println!("An integer: {:?}", copied_integer);
    println!("A boolean: {:?}", a_boolean);
    println!("Meet the unit value: {:?}", unit);

    // The compiler warns about unused variable bindings; these warnings can
    // be silenced by prefixing the variable name with an underscore
    // 使用されていない変数があると、コンパイラは警告を出します。
    // 変数名の頭に`_`（アンダーバー）を付けると警告を消すことができます。
    let _unused_variable = 3u32;

    let _noisy_unused_variable = 2u32;
    // FIXME ^ Prefix with an underscore to suppress the warning
    // Please note that warnings may not be shown in a browser
    // FIXME ^ 頭にアンダーバーを付けて、警告を抑えましょう。

    let _immutable_binding = 1;
    let mut mutable_binding = 1;

    println!("Before mutation: {}", mutable_binding);

    // Ok
    mutable_binding += 1;

    println!("After mutation: {}", mutable_binding);

    // Error! Cannot assign a new value to an immutable variable
    // エラー! イミュータブルな変数には新しい値を代入できません
    // _immutable_binding += 1;
    // FIXME ^ Comment out this line
    // FIXME ^ この行をコメントアウトしましょう


    // This binding lives in the main function
    // この変数はmain関数内が生息域です。
    let long_lived_binding = 1;

    // This is a block, and has a smaller scope than the main function
    // ここから下が`main`より小さいスコープを持つブロックとなります。
    {
        // This binding only exists in this block
        // この変数はこのブロック内のみに存在します。
        let short_lived_binding = 2;

        println!("inner short: {}", short_lived_binding);
    }
    // End of the block
    // ブロックの終わり

    // Error! `short_lived_binding` doesn't exist in this scope
    // `short_lived_binding`はこのスコープ内には存在しませんのでエラーとなります。
    // println!("outer short: {}", short_lived_binding);
    // FIXME ^ Comment out this line
    // FIXME ^ コメントアウトしましょう

    println!("outer long: {}", long_lived_binding);

    let shadowed_binding = 1;

    {
        println!("before being shadowed: {}", shadowed_binding);

        // This binding *shadows* the outer one
        // この変数はスコープ外の同名の変数を *シャドーイング* します
        let shadowed_binding = "abc";

        println!("shadowed in inner block: {}", shadowed_binding);
    }
    println!("outside inner block: {}", shadowed_binding);

    // This binding *shadows* the previous binding
    // この変数バインディングは以前に定義した変数を *シャドーイング* します
    let shadowed_binding = 2;
    println!("shadowed in outer block: {}", shadowed_binding);

    // Declare a variable binding
    // 変数を宣言
    let a_binding;

    {
        let x = 2;

        // Initialize the binding
        // 変数を初期化
        a_binding = x * x;
    }

    println!("a binding: {}", a_binding);

    let another_binding;

    // Error! Use of uninitialized binding
    // エラー！ 初期化していない変数の使用
    // println!("another binding: {}", another_binding);
    // FIXME ^ Comment out this line
    // FIXME ^ この行をコメントアウトしましょう。

    another_binding = 1;

    println!("another binding: {}", another_binding);


    let mut _mutable_integer = 7i32;

    {
        // Shadowing by immutable `_mutable_integer`
        // イミュータブルな`_mutable_integer`でシャドーイングする
        let _mutable_integer = _mutable_integer;

        // Error! `_mutable_integer` is frozen in this scope
        // エラー! `_mutable_integer`はこのスコープでは凍結している。
        // _mutable_integer = 50;
        // FIXME ^ Comment out this line
        // FIXME ^ この行をコメントアウトしましょう。

        // `_mutable_integer` goes out of scope
        // `_mutable_integer`はスコープを抜ける
    }

    // Ok! `_mutable_integer` is not frozen in this scope
    // OK! `_mutable_integer`はこのスコープでは凍結していない。
    _mutable_integer = 3;

}