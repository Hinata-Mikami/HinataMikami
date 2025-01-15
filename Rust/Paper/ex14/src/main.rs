use std::rc::Rc;

struct MyStruct {
    value: i32,
}

impl Drop for MyStruct {
    fn drop(&mut self) {
        println!("Dropping MyStruct with value: {}", self.value);
    }
}

fn main() {
    {
        let a = Rc::new(MyStruct { value: 1 });
        let b = Rc::clone(&a);
        println!("a: {}, b: {}", a.value, b.value);
        println!("Reference count: {}", Rc::strong_count(&a));
    }

    println!("Exited scope");
}

