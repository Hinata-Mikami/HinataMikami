use List::{Cons, Nil};
use std::rc::Rc;
use std::cell::RefCell;
use dumpster::{Trace, unsync::Gc};

#[derive(Trace)]
enum List {
    Cons(i32, RefCell<Gc<List>>),
    Nil,
}

impl List {
    fn tail(&self) -> Option<&RefCell<Gc<List>>> {
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
        let a = Gc::new(Cons(5, RefCell::new(Gc::new(Nil))));
        let b = Gc::new(Cons(10, RefCell::new(Gc::clone(&a))));

        if let Some(link) = a.tail() {
            *link.borrow_mut() = Gc::clone(&b);
        }

        
        // println!("{:?}", a.tail());  // stack overflow
        drop(a);
        drop(b); 
        dumpster::unsync::collect();
    }

    println!("End");

    // 要素の5や10はdropされていないことがわかる．
    // if let ... をコメントアウトして循環参照を解除すると
    // 5, 10は解放されている旨表示される
}

fn main(){
    list_example();
}