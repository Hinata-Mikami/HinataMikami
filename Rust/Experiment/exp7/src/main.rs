fn main() {
    //&str はプリミティブな型，変更不可.文字列スライスとも呼ばれる
    let a: &'static str = "Hello world!";
    let b: &'static str = "Hello world!";

    //https://doc.rust-lang.org/std/ptr/fn.eq.html
    println!("{}", std::ptr::eq(a, b)); //true

    let mut c: &'static str = "Hello world!";
    println!("{}", std::ptr::eq(a, c)); //true

    c = "Hello World!";
    println!("{}", std::ptr::eq(a, c)); //false

    //Stringは標準ライブラリの型．変更可．
    //Vec<u8>としてヒープ上に保存.
    let a = String::from("Hello world!");
    let b = String::from("Hello world!");

    println!("{}", std::ptr::eq(&a, &b)); //false
    
}