#![feature(register_tool)]
#![register_tool(rr)]
#![feature(custom_inner_attributes)]

use std::marker::PhantomData;

// --- ここを修正 ---
// このstructは「場所γを指すポインタ」としてモデル化する
#[rr::refined_by("p": "ptr<gname>")]
pub struct UnsafeAliasedPtr<'a> {
    // Rustのptrフィールドが、論理的なポインタpに対応することを明記
    #[rr::field("p")]
    ptr: *mut i32,
    _p: PhantomData<&'a ()>,
}

// implブロックのアノテーションも、新しいモデルに合わせて修正
impl<'a> UnsafeAliasedPtr<'a> {
    #[rr::params("v": "Z", "γ": "gname")]
    #[rr::args("(#v, γ)")]
    // 返り値は「場所γを指すポインタ」
    #[rr::returns("ptr_of(γ)")]
    pub fn new(x: &'a mut i32) -> Self {
        Self { ptr: x, _p: PhantomData }
    }

    #[rr::params("p": "ptr<gname>")]
    #[rr::args("(p)")]
    #[rr::returns("p")]
    pub fn clone_alias(&self) -> Self {
        Self { ptr: self.ptr, _p: PhantomData }
    }
    
    // `ptr_of(γ)`はγを指すポインタ、`v_new`は新しい値
    #[rr::params("v_old": "Z", "v_new": "Z", "γ": "gname")]
    #[rr::args("(ptr_of(γ))", "(v_new)")]
    #[rr::requires("γ ↦ v_old")]
    #[rr::observe("γ": "v_new")]
    #[rr::returns("()")]
    pub unsafe fn write(&self, val: i32) {
        *self.ptr = val;
    }

    // `ptr_of(γ)`はγを指すポインタ、`v`はその場所の値
    #[rr::params("v": "Z", "γ": "gname")]
    #[rr::args("(ptr_of(γ))")]
    #[rr::requires("γ ↦ v")]
    #[rr::returns("v")]
    pub unsafe fn read(&self) -> i32 {
        *self.ptr
    }
}

// --- `run_aliasing_assert`は変更なしでも良いが、より明示的に ---
#[rr::params("v_before": "Z", "γ": "gname")]
#[rr::args("(#v_before, γ)")]
#[rr::observe("γ": "1")]
#[rr::returns("()")]
pub fn run_aliasing_assert(x: &mut i32) {
    let p1 = UnsafeAliasedPtr::new(x);
    let p2 = p1.clone_alias();
    unsafe {
        p1.write(1);
        assert_eq!(p2.read(), 1);
    }
}

fn main() {
    let mut data = 0;
    run_aliasing_assert(&mut data);
    println!("Assertion passed! Final value of data: {}", data);
}