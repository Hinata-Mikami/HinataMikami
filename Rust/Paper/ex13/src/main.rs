use std::rc::Rc;

fn main() {
    
    let a = Rc::new(1);
    let b = Rc::clone(&a);
    println!("a: {}, b: {}", a, b);
    println!("Reference count: {}", Rc::strong_count(&a));

}

