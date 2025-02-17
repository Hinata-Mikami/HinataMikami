#[allow(unused_variables)]
#[allow(dead_code)]

fn main() {
    f11();
    f12();
    f13();
    f14();
    f15();
    f16();
    f21();
    f22();
    f23();
    f24();
    f25();
    f26();
    f31();
    f32();
    f33();
    f34();
    f35();
    f37();
    f43();
    f44();
    f45();
    f46();
    f53();
    f54();
    f55();
    scope_example();
    scope_example2();
    static_const_example();
    rc_example();
    list_example();
    arc_example();
    string_example();
}

#[derive(Clone)] // クローンに必要
struct Point{ x : i32, y : i32 }

impl Drop for Point {
    fn drop(&mut self) {
        println!("Dropping Point: x = {}, y = {}", self.x, self.y);
    }
}

fn f11(){
    let p = Point{x : 12, y : 345};
    // ... pを使うコード ...
}

fn f12(){
    let p = Point{x : 12, y : 345};
    // ... pを使うコード ...
    println!("p.x = {}", p.x);
    
    // ... pを使わないコード ...
    println!("The end of f12");
}

// この時点で，より早く解放したい場合の drop or del / null の議論 

fn f13(){
    let p = Point{x : 12, y : 345};
    // ... pを使うコード ...
    let q = p;
    // ... qを使うコード ...
    // let r = p; // Error
}

// p は python では使えるがrust では使えない

fn f14(){
    let p = Point{x : 12, y : 345};
    // ... p を使うコード ...
    g14(p);
    // ... p を使わないコード ...
}

fn g14(q : Point){
    // ... q を使うコード ...
    drop(q);
    println!("The end of g14");
}

fn f142(){
    let p = Point{x : 12, y : 345};
    // ...
    g142(p);
    // ...
    println!("The end of f142");
}

fn g142(q : Point){
    // ... 
    let q = Point{x : 0, y : 0};
    // ...
    println!("The end of g142");
}


fn f15(){
    let p = Point{x : 12, y : 345};
    // ... p を使うコード 
    let q = if false { p } 
            else {Point{x : 345, y : 12 }};
    // println!("{}", p.x); Error!
    println!("The end of f15");
}

fn f16(){
    let p = Point{x : 0, y : 0};
    // p = Point{x : 345, y : 12}; // Error!
    let p = Point{x : 12, y : 345};
    println!("The end of f16")
}

struct Mystruct{x : String, y : i32}

fn f17(){
    let p = Mystruct{x : String::from('x'), y : 345};
    let p_x = p.x;
    let p_x2 = p.x; // Error
    // let q = p;      // Error
    let p_y = p.y;
    // ...
    println!("The end of f17")
}


fn f21(){
    let mut p = Point{x : 12, y : 345};
    // ... pを使うコード ...
}

fn f22(){
    let mut p = Point{x : 12, y : 345};
    // ... pを使うコード ...
    println!("here");
    // ... pを使わないコード ...
}

fn f23(){
    let mut p = Point{x : 12, y : 345};
    // ... pを使うコード ...
    let q = p;
    // ... qを使うコード ...
}

fn f24(){
    let mut p = Point{x : 12, y : 345};
    // ... pを使うコード ...
    g24(p);
}

fn g24(q : Point){
    q = Point{x : 0, y : 0};
    println!("The end of g24")
}


fn f25(){
    let mut p = Point{x : 12, y : 345};
    // ... pを使うコード ...
    let mut q = if false { 
                p; 
            } else {
                Point{x : 345, y : 12 };
            };
    //println!("{}", p.x); //Error!
}

fn f26(){
    let mut p = Point{x : 0, y : 0};
    p = Point{x : 12, y : 345};          // 再代入
    println!("p.x = {}", p.x);
    let mut p = Point{x : 67, y : 890};  // シャドーイング
    println!("The end of f16")
}
// mut は指してるオブジェクトが変わる？自分自身が変わる？mutの意味は？


fn f31(){
    let p = Point{x : 12, y : 345};
    let q = &p;
    // ... p や q を使うコード ...
    println!("p.x = {}", p.x);
    println!("q.x = {}", q.x); 
}

fn f32(){
    let p = Point{x : 12, y : 345};
    let q = &p;
    let r = &p;
    // ... q や r を使うコード ...
    println!("q.x = {}", q.x);
    println!("r.x = {}", r.x);     
}

fn f33(){
    let p = Point{x : 12, y : 345};
    let q = &p;
    let r = q;
    let s = &r;  // 不変参照の不変参照
    // ...
    println!("q.x = {}", q.x);  // 所有権は存在しない
    println!("s.x = {}", s.x);
}



fn f36(){
    let p = Point{x : 12, y : 345};
    let q = &p;
    // ...
    let p = Point{x : 0, y : 0};    // シャドーイング
    println!("p.x = {}", p.x);
    println!("q.x = {}", q.x);
}

fn f37(){
    let p = Point{x : 12, y : 345};
    let p_x = &p.x;
    let p_y = &p.y;
    println!("{}", p.x); 
}



fn f41(){
    let mut p = Point{x : 12, y : 345};
    let q = &mut p;
    // ... q を使うコード ...
    // println!("p.x = {}", p.x);   // Error
    println!("q.x = {}", q.x);      // q のライフタイム終了
    println!("p.x = {}", p.x);      // Ok
}

fn f42(){
    let mut p = Point{x : 12, y : 345};
    let q = &mut p;
    // let r = &mut p;          // Error (不変参照も不可)
    // ... q を使うコード ...
    println!("q.x = {}", q.x);  // q のライフタイム終了
    let r = &mut p;             // Ok  
}


fn f43(){
    let mut p = Point{x : 12, y : 345};
    let q = &mut p;
    let r = q;
    let s = &mut r;
    // ...
    println!("s.x = {}", s.x);
}

fn f461(){
    let mut p = Point{x : 12, y : 345};
    let q = &mut p;
    *q = Point{x : 345, y : 12};    // 元の値は drop
    // p.x = 0;                     // Error
    // ... q を使用するコード ... 
    println!("q.x = {}", q.x);      // ライフタイム終了
    // ... q を使用しないコード ...   // p は使用できる
    println!("p.x = {}", p.x);
}

fn f46(){
    let mut p = Point{x : 12, y : 345};
    let q = &mut p;
    *q = Point{x : 345, y : 12};    // p への再代入 元の値が drop
    let p = Point{x : 0, y : 0};    // シャドーイング
    println!("p.x = {}", p.x);      // p は再定義されているので使用可能
    println!("q.x = {}", q.x);      // q のライフタイム終了
}

fn f53(){
    let p = Point{x : 12, y : 345};
    let q = p.clone();      // Rust のクローンは Rc 等を除き deepcopy
    // ... p や q を使うコード ...
}

fn f54(){
    let p = Point{x : 12, y : 345};
    // ... pを使うコード ...
    g54(p.clone());
}

fn g54(q : Point){
    // ... qを使うコード ...
}

fn f55(){
    let p = Point{x : 12, y : 345};
    // ... pを使うコード ...
    let q = if false { 
                p.clone(); 
            } else {
                Point{x : 345, y : 12 };
            };
    println!("{}", p.x); 
}

fn scope_example0() {
    let mut p = Point{x : 12, y : 345};
    {
        let mut q = p;
        println!("{}", q.x);
        q = Point{x : 0, y : 0};    // 再代入 元の値 drop
        // ... 実行時間の長いコード ...
        println!("Inner scope end");
    }
    println!("Function end");
}

fn scope_example() {
    let mut p = Point{x : 12, y : 345};
    let mut q = Point{x : 345, y : 12};
    {
        q = p;                // p1 の値が drop
        println!("{}", q.x);
        // 実行時間の長いコード
    }
    println!("End");
}

fn scope_example2() {
    let p1 = Point{x : 12, y : 345};
    {
        let p1 = Point{x : 0, y : 0};
        println!("inside : {}", p1.x);
    }
    println!("outside : {}", p1.x);
}

static HELLO: &str = "Hello";
const WORLD: &str = "World";
static mut COUNTER: i32 = 0;

fn incr_count() {
    unsafe {
        COUNTER += 1;
    }
} 

fn static_const_example() {
    println!("{}, {}!", HELLO, WORLD);

    unsafe {
        incr_count();
        println!("Count: {}", COUNTER);
    }
}

fn rc_example() {
    
    let a = Rc::new(RefCell::new(Point{x : 0, y : 0}));
    let b = Rc::clone(&a);
    b.borrow_mut().x = 1;
    println!("a.x: {}, b.x: {}", a.borrow().x, b.borrow().x);
    println!("Reference count: {}", Rc::strong_count(&a));

}


use List::{Cons, Nil};
use std::rc::Rc;
use std::cell::RefCell;

enum List {
    Cons(i32, RefCell<Rc<List>>),
    Nil,
}

impl List {
    fn tail(&self) -> Option<&RefCell<Rc<List>>> {
        match *self {
            Cons(_, ref item) => Some(item),
            Nil => None,
        }
    }
}

impl Drop for List {
    fn drop(&mut self) {
        match self {
            List::Cons(value, _) => {
                println!("Dropping Cons with value: {}", value);
            }
            List::Nil => {
                println!("Dropping Nil");
            }
        }
    }
}

fn list_example() {
    {
        let a = Rc::new(Cons(5, RefCell::new(Rc::new(Nil))));
        let b = Rc::new(Cons(10, RefCell::new(Rc::clone(&a))));

        if let Some(link) = a.tail() {
            *link.borrow_mut() = Rc::clone(&b);
        }
        
        // println!("{:?}", a.tail());  // stack overflow
        drop(a);
        drop(b); 
    }

    println!("End");  // Cons(5, _) や Cons(10, _) は drop されない

}


// arc, mutex 
use std::time::Duration;
use std::sync::{Arc, Mutex};
use std::thread;

fn arc_example() {
    let numbers: Arc<Mutex<Vec<i32>>> 
                = Arc::new(Mutex::new(vec![]));

    for i in 0..5 {
        let numbers = Arc::clone(&numbers);

        thread::spawn(move || {
            let mut locked_numbers 
                    = numbers.lock().unwrap();
            locked_numbers.push(i);
            println!("{:?}", locked_numbers);
            // 実行時間の長いコード
        });
    }

    thread::sleep(Duration::from_secs(1));
}

fn string_example() {
    let mut s1 = String::from("s1");
    
    let s2 = &mut s1;
    s2.push_str(" : modified");
    println!("{}", s2);
    println!("{}", s1);
}