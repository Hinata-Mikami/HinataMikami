use std::rc::Rc;
use std::cell::RefCell;

struct Point{x : i32, y : i32}

fn rc_example() {
    
    let a = Rc::new(RefCell::new(Point{x : 0, y : 0}));
    let b = Rc::clone(&a);
    b.borrow_mut().x = 1;
    println!("a.x: {}, b.x: {}", a.borrow().x, b.borrow().x);
    println!("Reference count: {}", Rc::strong_count(&a));

}

fn main() {
    rc_example();
}
