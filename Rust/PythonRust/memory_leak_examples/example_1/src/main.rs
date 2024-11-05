use std::collections::HashMap;
use std::rc::Rc;
use std::cell::RefCell;

// ClassBに相当する構造体
struct ClassB {
    values: RefCell<HashMap<*const ClassA, String>>, // ポインタ型に変更
}

impl ClassB {
    fn new() -> Self {
        ClassB {
            values: RefCell::new(HashMap::new()),
        }
    }

    fn add(&self, instance: Rc<ClassA>, name: String) {
        let ptr = Rc::as_ptr(&instance); // ポインタとして格納
        self.values.borrow_mut().insert(ptr, name);
    }
}


#[derive(Clone)]
struct ClassA {
    name: String,
    class_b: Rc<ClassB>,
}

impl ClassA {
    fn new(class_b: Rc<ClassB>, name: String) -> Self {
        ClassA { name, class_b }
    }

    fn add(&self) {
        self.class_b.add(Rc::new(self.clone()), self.name.clone());
    }
}


// 実行用関数
fn run(class_b: Rc<ClassB>) {
    let class_a = Rc::new(ClassA::new(class_b.clone(), String::from("class A")));
    class_a.add();
    println!("values: {:?}", class_b.values.borrow());
}


// ループ実行
fn loop_run() {
    let class_b = Rc::new(ClassB::new());
    for _ in 0..3 {
        run(class_b.clone());
    }
}


fn main() {
    loop_run();
}
