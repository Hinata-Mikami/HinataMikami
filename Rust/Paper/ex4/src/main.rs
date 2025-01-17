fn main() {
    let mut s1 = String::from("s1");
    
    let s2 = &mut s1;
    s2.push_str(" : modified");
    println!("{}", s2);
    println!("{}", s1);
}

