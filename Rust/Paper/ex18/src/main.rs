fn main() {
    let mut s = String::from("Hello");

    // as_str : 先頭要素へのポインタ
    let ptr_before = s.as_ptr();
    println!("before: {:?}, {}", ptr_before, s);

    s.push_str("!");
    let ptr_after = s.as_ptr();
    println!("after:  {:?}, {}", ptr_after, s);
}
