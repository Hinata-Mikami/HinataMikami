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
    let p1 = Point{x : 12, y : 345};
    {
        let p1 = Point{x : 0, y : 0};
        println!("inside : {}", p1.x);
    }
    println!("outside : {}", p1.x);
}

fn main() {
    function();
    println!("The end of the main function");
}
