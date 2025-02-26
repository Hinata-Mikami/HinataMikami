#[allow(unused_variables)]
#[allow(dead_code)]

#[derive(Clone)] // クローンに必要
struct Point{ x : i32, y : i32 }

impl Drop for Point {
    fn drop(&mut self) {
        println!("Dropping Point: x = {}, y = {}", self.x, self.y);
    }
}


fn function() {
    let mut s1 = String::from("s1");
    
    let s2 = &mut s1;
    s2.push_str(" : modified");
    println!("{}", s2);
    println!("{}", s1);
}
fn main() {
    function();
    println!("main end");
}
