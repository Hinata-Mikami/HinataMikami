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
        let b = Rc::new(Cons(10, RefCell::new(Rc::clone(&a))));

        if let Some(link) = a.tail() {
            *link.borrow_mut() = Rc::clone(&b);
        }

        drop(a);
        drop(b); 
    }

    println!("Hello world!");

    // 要素の5や10はdropされていないことがわかる．
    // if let ... をコメントアウトして循環参照を解除すると
    // 5, 10は解放されている旨表示される
}
