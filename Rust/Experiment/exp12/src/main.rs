use List::{Cons, Nil};
use std::rc::Rc;
use std::cell::RefCell;
#[derive(Debug)]
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

// デバッグ用にDropトレイトを実装
// https://doc.rust-jp.rs/book-ja/ch15-03-drop.html
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

fn main() {
    {
        let a = Rc::new(Cons(5, RefCell::new(Rc::new(Nil))));

        // aの最初の参照カウント = {}
        println!("a initial rc count = {}", Rc::strong_count(&a));
        // aの次の要素は = {:?}
        println!("a next item = {:?}", a.tail());

        let b = Rc::new(Cons(10, RefCell::new(Rc::clone(&a))));

        // b作成後のaの参照カウント = {}
        println!("a rc count after b creation = {}", Rc::strong_count(&a));
        // bの最初の参照カウント = {}
        println!("b initial rc count = {}", Rc::strong_count(&b));
        // bの次の要素 = {:?}
        println!("b next item = {:?}", b.tail());

        if let Some(link) = a.tail() {
            *link.borrow_mut() = Rc::clone(&b);
        }



        // aを変更後のbの参照カウント = {}
        println!("b rc count after changing a = {}", Rc::strong_count(&b));
        // aを変更後のaの参照カウント = {}
        println!("a rc count after changing a = {}", Rc::strong_count(&a));
        

        // 次の行のコメントを外して循環していると確認してください; スタックオーバーフローします
        // println!("a next item = {:?}", a.tail());        // aの次の要素 = {:?}

        if let Some(link) = a.tail() {
            *link.borrow_mut() = Rc::new(Nil);
        }      
        drop(a);
        drop(b); 
    }

    //println!(Rc::strong_count(&a)); //Error! aはスコープから外れている
    println!("Hello world!");

    // 要素の5や10はdropされていないことがわかる．
    // if let ... をコメントアウトして循環参照を解除すると5, 10は解放されている旨表示される
}
