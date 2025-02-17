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
    // ... pを使うコード ...
    g24(p);
}

fn g24(mut q : Point){
    q = Point{x : 0, y : 0};    // 元の値を drop
    // ... 実行時間の長いコード ...
    println!("The end of g24")
}

fn main() {
    function();
    println!("The end of the main function");
}
