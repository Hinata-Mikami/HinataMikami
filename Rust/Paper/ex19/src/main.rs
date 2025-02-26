#[derive(Clone)]
struct Person {
    name: String,
    age: u32,
}
impl Drop for Person {
    fn drop(&mut self) {
        println!("Dropping Person: name = {}", self.x);
    }
}


fn function() {
    let p = Person {
        name: String::from("Alice"),
        age: 30,
    };

    let name = p.name; // `name` の所有権をムーブ
    println!("Name: {}", name);
}

fn main() {
    function();
    println!("main end");
}
