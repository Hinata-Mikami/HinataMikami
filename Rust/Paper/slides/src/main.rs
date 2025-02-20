#[allow(unused_variables)]
#[allow(dead_code)]

#[derive(Clone, Debug)] 
struct Point{ x : i32, y : i32 }

impl Drop for Point{
    fn drop(&mut self) {
        println!("Dropping : ({}, {})", self.x, self.y);
    }
}

fn main() {
    f6();
    println!("main end");
}

fn f1() {

    let p=Point{x:12, y:345};
    // ...
    println!("f1 end");

} // Point はここで解放される


fn f2(){

    let p = Point{x:12, y:345};
    // ... 
    let q = p;  // 所有権が移動
    // ...

}


fn f3(){

    let p = Point{x:12, y:345};

{
    let q = p;
      // ...
}   // ここで Point が解放
    // ... 
    println!("f3 end");
}


fn f4(){

    let p = Point{x:12, y:345};
    // ...
    g4(p);  // 所有権が移動
    println!("here");
    // ...
}

fn g4(q : Point){

    // ... q を使うコード ...
    println!("The end of g4");

}   // ここで Point が解放　

fn f5(){

    // 再代入には mut が必要
    let mut p = Point{x:0, y:0};    
    // ...

    // 再代入
    p = Point{x : 345, y : 12}; 
    println!("p.x = {}", p.x);
    println!("The end of f5")
}

fn f6(){

    let mut p=Point{x:12,y:345};
    // ...
    g6(p);
}

fn g6(mut q : Point){
    // ... 
    q = Point{x:0, y:0};
    // 元の値は解放される
    // ...実行時間の長いコード
    println!("The end of g6")
}



