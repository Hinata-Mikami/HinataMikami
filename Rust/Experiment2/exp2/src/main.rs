fn main() {
    let s = String::from("Hello, world!");
    let l = &s.len();   // 借用（参照）
    println!("The length of '{}' is {}.", s, l);
}
