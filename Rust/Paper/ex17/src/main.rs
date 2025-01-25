use std::time::Duration;
use std::sync::Arc;
use std::thread;
use std::sync::Mutex;

fn main() {

    let apple: Arc<Mutex<String>> 
        = Arc::new(Mutex::new(String::from("an apple")));

    for i in 0..10 {
        let apple: Arc<Mutex<String>> = Arc::clone(&apple);

        thread::spawn(move || {
            let mut locked_apple = apple.lock().unwrap();
            *locked_apple = format!("thread {}'s apple", i);
            println!("Modified: {}", locked_apple);
        });
    }

    thread::sleep(Duration::from_secs(1));
}

