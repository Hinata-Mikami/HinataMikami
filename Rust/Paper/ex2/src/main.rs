fn main() {
    let s1 : String = String::from("s1");
    
    let s2 = &s1;
    println!("{}", s2);
    println!("{}", s1);
}
