#[allow(unused_variables)]
#[allow(dead_code)]

#[derive(Clone)] 
struct Point{ x : i32, y : i32 }

impl Drop for Point {
    fn drop(&mut self) {
        println!("Dropping Point: x = {}, y = {}", self.x, self.y);
    }
}


fn function() {
    let mut x = Point{x:0, y:0};
    x = Point{x:1, y:1};
    let x = Point{x:2, y:2};
    println!("here")
}

fn main() {
    function();
    println!("The end of the main function");
}
