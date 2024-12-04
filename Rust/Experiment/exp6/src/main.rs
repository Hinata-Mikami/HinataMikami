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

}

