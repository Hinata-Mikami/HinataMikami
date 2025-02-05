static HELLO: &str = "Hello";
const WORLD: &str = "World";
static mut COUNTER: i32 = 0;

fn incr_count() {
    unsafe {
        COUNTER += 1;
    }
} 

fn function() {
    println!("{}, {}!", HELLO, WORLD);

    unsafe {
        incr_count();
        println!("Count: {}", COUNTER);
    }
}

fn main() {
    function();
}