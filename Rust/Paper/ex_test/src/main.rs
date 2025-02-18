#[allow(unused_variables)]
#[allow(dead_code)]

#[derive(Clone, Debug)] 
struct Point{ x : i32, y : i32 }

// Drop トレイト
// デストラクタ実行時に自動で呼ばれる drop メソッドを定義 
impl Drop for Point{
    fn drop(&mut self) {
        println!("Dropping : ({}, {})", self.x, self.y);
    }
}


fn function() {
    let p = Point{x : 12, y : 345};
    {
        let q = p;
    }
    println!("f2 end");
}


fn main() {
    function();
    println!("main end");
}
