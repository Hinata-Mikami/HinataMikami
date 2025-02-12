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

fn f11(){
    let p = Point{x : 12, y : 345};
    // ... pを使うコード ...
}

fn f12(){
    let p = Point{x : 12, y : 345};
    // ... pを使うコード ...
    println!("here");
    // ... pを使わないコード ...
}

// この時点で，より早く解放したい場合の drop or del / null の議論 

fn f13(){
    let p = Point{x : 12, y : 345};
    // ... pを使うコード ...
    let q = p;
    // ... qを使うコード ...
}

// p は python では使えるがrust では使えない

fn f14(){
    let p = Point{x : 12, y : 345};
    // ... pを使うコード ...
    g14(p);
}

fn g14(q : Point){
    // ... qを使うコード ... // ここでpython で q = None をしても消えないがRustでは消える
}


fn f15(){
    let p = Point{x : 12, y : 345};
    // ... pを使うコード ...
    let q = if false { 
                p; //このpのdropはいつ？
            } else {
                Point{x : 345, y : 12 };
            };
    // println!("{}", p.x); Error!
}

fn f16(){
    let p = Point{x : 12, y : 345};
    // drop(p) するとうまくいくの？Python で書いた時の解放のタイミングを比較して...
    // p = Point{x : 345, y : 12}; Error!
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
    // ... qを使うコード ...
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
    let mut p = Point{x : 12, y : 345};
    p = Point{x : 345, y : 12};
}
// mut は指してるオブジェクトが変わる？自分自身が変わる？mutの意味は？


fn f33(){
    let p = Point{x : 12, y : 345};
    // ... pを使うコード ...
    let q = &p;
    // ... qを使うコード ...
}

fn f34(){
    let p = Point{x : 12, y : 345};
    // ... pを使うコード ...
    g34(&p);
}

fn g34(q : &Point){
    // ... qを使うコード ...
}

fn f35(){
    let p = Point{x : 12, y : 345};
    // ... pを使うコード ...
    let q = if false { 
                &p; 
            } else {
                &Point{x : 345, y : 12 };
            };
    println!("{}", p.x); 
}

fn f37(){
    let p = Point{x : 12, y : 345};
    let p_x = &p.x;
    let p_y = &p.y;
    println!("{}", p.x); 
}

fn f43(){
    let mut p = Point{x : 12, y : 345};
    // ... pを使うコード ...
    let q = &mut p;
    // ... qを使うコード ...
}

fn f44(){
    let mut p = Point{x : 12, y : 345};
    // ... pを使うコード ...
    g44(&mut p);
}

fn g44(q : &Point){
    // ... qを使うコード ...
}

fn f45(){
    let mut p = Point{x : 12, y : 345};
    // ... pを使うコード ...
    let mut q = if false { 
                &mut p; 
            } else {
                &mut Point{x : 345, y : 12 };
            };
    println!("{}", p.x); 
}

fn f46(){
    let mut p = Point{x : 12, y : 345};
    let mut q = &mut p;
    *q = Point{x : 345, y : 12};
}

fn f53(){
    let p = Point{x : 12, y : 345};
    // ... pを使うコード ...
    let q = p.clone();
    // ... qを使うコード ...
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

fn scope_example() {
    let p = Point{x : 12, y : 345};
    {
        let q = p;
        println!("{}", q.x);
        
    }
    // 実行時間の長いコード
}

fn scope_example2() {
    let p1 = Point{x : 12, y : 345};
    let p2 = Point{x : 345, y : 12};
    {
        let p2 = p1;
        println!("{}", p2.x);
        
    }
    println!("{}", p2.x);
    // 実行時間の長いコード
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

    println!("Hello world!");

    // 要素の5や10はdropされていないことがわかる．
    // if let ... をコメントアウトして循環参照を解除すると
    // 5, 10は解放されている旨表示される
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