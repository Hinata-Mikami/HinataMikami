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
    *q =  Point{x : 345, y : 12};    // 元の値は drop
    // p.x = 0;                     // Error
    // ... q を使用するコード ... 
    println!("q.x = {}", q.x);      // ライフタイム終了
    // ... q を使用しないコード ...   // p は使用できる
    println!("p.x = {}", p.x);
}

fn main() {
    function();
    println!("The end of the main function");
}
