struct MyString(String);

impl Drop for MyString {
    fn drop(&mut self) {
        println!("Dropping MyString: {}", self.0);
    }
}

fn take_ownership(s: MyString) {
    println!("In take_ownership: {}", s.0);
}

fn borrow_string(s: &MyString) {
    println!("In borrow_string: {}", s.0);
}

fn borrow_mut_string(s: &mut MyString) {
    s.0.push_str(" (modified)");
    println!("In borrow_mut_string: {}", s.0);
}

fn main() {
    let s1 = MyString(String::from("A"));
    take_ownership(s1);
    // println!("{}", s1.0); // Error

    let s2 = MyString(String::from("B"));
    borrow_string(&s2);
    println!("main borrow_string: {}", s2.0); 

    let mut s3 = MyString(String::from("C"));
    borrow_mut_string(&mut s3);
    println!("main borrow_mut_string: {}", s3.0); 

    println!("L.35");
}


