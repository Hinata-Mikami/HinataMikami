struct MyString(String);

// struct MyStr(&str);  
// Error : expected named lifetime parameter

struct MyStr<'a>(&'a str);
// OK

impl Drop for MyString {
    fn drop(&mut self) {
        println!("Dropping MyString: {}", self.0);
    }
}

impl Drop for MyStr<'_> {
    fn drop(&mut self) {
        println!("Dropping MyStr: {}", self.0);
    }
}

fn main() {
    let s1 = MyString(String::from("A"));
    let s2 = MyStr("B");

    {
        let s11 = s1; // 所有権が移動 s1 
        println!("{}", s11.0);
    }   // s11解放
    // println!("{}", s1.0); 不可
    println!("L.30");

    {
        let s21 = s2; // 所有権が移動 s1 
        println!("{}", s21.0);
    }   // s21解放  
    // println!("{}", s2.0); 不可
    println!("L.37");

    // &str : メモリへの参照型・所有権はない
    let s3 = "C";
    {
        let s31 = s3;
        println!("{}", s31);
    }
    println!("{}", s3); //これは可
}