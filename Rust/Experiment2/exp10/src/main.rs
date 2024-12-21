// https://doc.rust-jp.rs/book-ja/ch15-06-reference-cycles.html

use std::cell::RefCell;
use std::rc::Rc;

struct Node {
    next: Option<Rc<RefCell<Node>>>,
}

fn main() {
    let node1 = Rc::new(RefCell::new(Node { next: None }));
    let node2 = Rc::new(RefCell::new(Node { next: Some(node1.clone()) }));
    node1.borrow_mut().next = Some(node2.clone()); // 循環参照がここで発生
}
