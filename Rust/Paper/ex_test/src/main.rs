#[allow(unused_variables)]
#[allow(dead_code)]

#[derive(Clone, Debug)] 
struct Point{ x : i32, y : i32 }

impl Drop for Point{
    fn drop(&mut self) {
        println!("Dropping Point: x = {}, y = {}", self.x, self.y);
    }
}


fn function() {
    let mut p = Point{x : 12, y : 345};
    let q = &mut p;
    // ... q を使うコード ...
    // println!("p.x = {}", p.x);  // Error
    println!("q.x = {}", q.x);
    println!("p.x = {}", p.x);     // Ok
}


fn main() {
    function();
    println!("The end of the main function");
}
