fn main() {
    let mut s = String::from("Hello");
    (&mut s).push_str(", world!");  //可変借用
    println!("{}", s);
}
