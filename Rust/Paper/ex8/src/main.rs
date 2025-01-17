static HELLO: &str = "Hello";
const WORLD: &str = "World";
static mut COUNTER: i32 = 0;

fn incr_count() {
    unsafe {
        COUNTER += 1;
    }
} 

fn main() {
    println!("{}, {}!", HELLO, WORLD);

    // 可変な静的変数を使用する際はunsafeブロックが必要
    unsafe {
        incr_count();
        println!("Count: {}", COUNTER);
    }
}
