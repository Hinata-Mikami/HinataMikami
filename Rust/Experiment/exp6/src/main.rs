// use std::rc::Rc;
// use std::cell::RefCell;

// struct C {
//     next: Option<Rc<RefCell<C>>>
// }

// impl C {
//     fn new() -> Rc<RefCell<Self>> {
//         Rc::new(RefCell::new(C { next: None }))
//     }
// }

// fn main() {
//     let class1 = C::new();
//     let class2 = C::new();

//     class1.borrow_mut().next = Some(Rc::clone(&class2));
//     class2.borrow_mut().next = Some(Rc::clone(&class1));
// }

use std::rc::{Rc, Weak};
use std::cell::RefCell;

struct C {
    next: Option<Weak<RefCell<C>>>
}

impl C {
    fn new() -> Rc<RefCell<Self>> {
        Rc::new(RefCell::new(C { next: None }))
    }
}

fn main() {
    let class1 = C::new();
    let class2 = C::new();

    class1.borrow_mut().next = Some(Rc::downgrade(&class2));
    class2.borrow_mut().next = Some(Rc::downgrade(&class1));

    // デバッグのための出力
    // = の右側をデストラクトしたら Some(...)になるとき実行される
    //Rc::ptr_eq アドレスに格納されている値を参照し，==ならtrueを返す
    if let Some(next_weak) = &class1.borrow().next {
        if let Some(next_rc) = next_weak.upgrade() {
            println!("class1 points to class2: {:?}", Rc::ptr_eq(&next_rc, &class2));
        } else {
            println!("class1's next is no longer valid");
        }
    }

    if let Some(next_weak) = &class2.borrow().next {
        if let Some(next_rc) = next_weak.upgrade() {
            println!("class2 points to class1: {:?}", Rc::ptr_eq(&next_rc, &class1));
        } else {
            println!("class2's next is no longer valid");
        }
    }

}

