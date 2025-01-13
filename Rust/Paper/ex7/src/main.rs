fn main() {
    let s1 = vec![String::from("s1")];

    let mut s2 = s1.clone();
    s2[0].push_str(" : modified");
    println!("{}", s1[0]);
    println!("{}", s2[0]);

}