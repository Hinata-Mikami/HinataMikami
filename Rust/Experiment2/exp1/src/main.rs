fn main() {
    let s1 = String::from("Hello, world!");
    let s2 = s1; // 所有権が移動
    println!("{}", s2);
}
