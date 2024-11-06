use std::cell::RefCell;
use std::collections::HashMap;
use std::rc::Rc;

//属性定義
struct ClassB {
    //Hashmap:dictのようなもの
    //Refcell:内部可変参照
    //Python:インスタンスをKeyにできたがRustは不可
    //->インスタンスのアドレスを整数型として使用
    values: RefCell<HashMap<usize, String>>,
}

//メソッド
impl ClassB {
    //__init__
    fn new() -> Self {
        Self {
            values: RefCell::new(HashMap::new()),
        }
    }

    //ClassBの可変参照を受け取り(borrow_mut), instance と name の対応を追加
    fn add(&self, instance: usize, name: String) {
        self.values.borrow_mut().insert(instance, name);
    }
}

//属性定義
struct ClassA {
    class_b: Rc<ClassB>,
}

//メソッド
impl ClassA {
    fn new(class_b: Rc<ClassB>) -> Self {
        Self { class_b }
    }

    fn add(&self, name: String) {
        // 呼び出しているインスタンス(class_a)のポインタ
        let instance = self as *const _ as usize; 
        self.class_b.add(instance, name);
    }
}

fn run(class_b: Rc<ClassB>) {
    //ClassAのインスタンス．
    //呼び出すたびにcloneで参照を増やす
    let class_a = ClassA::new(class_b.clone());
    class_a.add("class A".to_string());

    //不変参照（print用）
    let values = class_a.class_b.values.borrow();
    println!("values: {:?}", *values);
}

fn loop_run() {
    //
    let class_b = Rc::new(ClassB::new());
    for _ in 0..3 {
        run(class_b.clone());
    }
}

fn main() {
    loop_run();
}
