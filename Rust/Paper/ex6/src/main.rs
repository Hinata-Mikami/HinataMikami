fn main() {

    let s1 = String::from("s1");
    let mut s2 = s1.clone();
    s2.push_str(" : modified");
    println!("{}", s1);
    println!("{}", s2);

}

