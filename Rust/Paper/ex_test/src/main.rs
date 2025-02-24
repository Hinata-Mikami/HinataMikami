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
    let mut p = Point{x : 12, y : 345};
    let q = &mut p;
    // ... q を使用するコード ... 
    *q = Point{x : 0, y : 0};       // q のライフタイム終了
    // ... q を使用しない実行時間の長いコード ...
    println!("p.x = {}", p.x);      // ok
}

fn main() {
    function();
    println!("main end");
}
