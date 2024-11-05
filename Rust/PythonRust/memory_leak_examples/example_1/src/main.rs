use std::cell::RefCell;
use std::collections::HashMap;
use std::rc::Rc;

struct ClassB {
    values: RefCell<HashMap<usize, String>>,
}

impl ClassB {
    fn new() -> Self {
        Self {
            values: RefCell::new(HashMap::new()),
        }
    }

    fn add(&self, instance_id: usize, name: String) {
        self.values.borrow_mut().insert(instance_id, name);
    }
}

struct ClassA {
    class_b: Rc<ClassB>,
}

impl ClassA {
    fn new(class_b: Rc<ClassB>) -> Self {
        Self { class_b }
    }

    fn add(&self, name: String) {
        let instance_id = self as *const _ as usize; // Using the address as a unique identifier
        self.class_b.add(instance_id, name);
    }
}

fn run(class_b: Rc<ClassB>) {
    let class_a = ClassA::new(class_b.clone());
    class_a.add("class A".to_string());

    let values = class_b.values.borrow();
    println!("values: {:?}", *values);
}

fn loop_fn() {
    let class_b = Rc::new(ClassB::new());
    for _ in 0..3 {
        run(class_b.clone());
    }
}

fn main() {
    loop_fn();
}
