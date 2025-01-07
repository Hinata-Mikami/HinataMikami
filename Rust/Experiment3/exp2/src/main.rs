static HELLO: &str = "Hello, world!";
const LANG: &str = "Rust";
static mut COUNTER: i32 = 0;

fn incr_count() {
    unsafe {
        COUNTER += 1;
    }
} 

fn main() {

    println!("{} {}", HELLO, LANG);

    // 可変な静的変数を操作する際はunsafeブロックが必要
    unsafe {
        COUNTER += 1;
        incr_count();
        println!("Count: {}", COUNTER);
    }
}
