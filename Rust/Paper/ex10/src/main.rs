fn main() {
    let s1 = String::from("s1");

    {
        let s11 = s1;
        println!("{}", s11);
    }
    // println!("{}", s1;  Error!
}
