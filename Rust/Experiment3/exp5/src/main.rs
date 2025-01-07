// https://doc.rust-jp.rs/rust-by-example-ja/std/arc.html?highlight=ARC#arc
// スレッド間で所有権を共有　RCを使用
use std::time::Duration;
use std::sync::Arc;
use std::thread;

fn main() {

    let apple = Arc::new("the same apple");

    for _ in 0..10 {

        let apple = Arc::clone(&apple);

        // https://doc.rust-lang.org/std/thread/fn.spawn.html
        thread::spawn(move || {
            println!("{:?}", apple);
        });
    }

    thread::sleep(Duration::from_secs(1));


    let apple2: Arc<std::sync::Mutex<String>> = Arc::new(std::sync::Mutex::new(String::from("an apple")));

    for i in 0..10 {
        let apple2: Arc<std::sync::Mutex<String>> = Arc::clone(&apple2);

        thread::spawn(move || {
            // Mutexをロックして値にアクセス
            let mut locked_apple2 = apple2.lock().unwrap();
            *locked_apple2 = format!("thread {}'s apple", i);
            println!("Modified: {}", locked_apple2);
        });
    }

    // スレッド終了を待つ
    thread::sleep(Duration::from_secs(1));

}
