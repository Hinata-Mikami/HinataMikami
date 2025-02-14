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
    let p = Point{x : 12, y : 345};
    // ... pを使うコード ...
    g142(p);
    println!("The end of f142");
}

fn g142(q : Point){
    // ... qを使うコード ...
    let q = Point{x : 0, y : 0};
    // ... 実行時間の長いコード ...
    println!("The end of g142");
}


fn main() {
    function();
    println!("The end of the main function");
}
