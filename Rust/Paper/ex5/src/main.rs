fn main() {
    let mut s1 = vec![String::from("s1")];

    let s2 = &mut s1;
    s2[0].push_str(" : modified");
    println!("{}", s2[0]);
    println!("{}", s1[0]);
}
