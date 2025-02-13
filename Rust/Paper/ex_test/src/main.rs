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

}

fn main() {
    function();
}
