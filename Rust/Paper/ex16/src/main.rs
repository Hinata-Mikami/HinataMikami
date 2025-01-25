// https://doc.rust-jp.rs/rust-by-example-ja/std/arc.html?highlight=ARC#arc
// スレッド間で所有権を共有　RCを使用
use std::sync::Arc;
use std::thread;
use std::time::Duration;

fn main() {
    let num = Arc::new("the same apple");

    for _ in 0..10 {

        let apple = Arc::clone(&apple);

        // https://doc.rust-lang.org/std/thread/fn.spawn.html
        thread::spawn(move || {
            println!("{:?}", apple);
        });
    }

    thread::sleep(Duration::from_secs(1));
}
