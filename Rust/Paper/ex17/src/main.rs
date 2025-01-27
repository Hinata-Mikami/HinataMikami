use std::time::Duration;
use std::sync::{Arc, Mutex};
use std::thread;

fn main() {
    let numbers: Arc<Mutex<Vec<i32>>> 
                = Arc::new(Mutex::new(vec![]));

    for i in 0..5 {
        let numbers = Arc::clone(&numbers);

        thread::spawn(move || {
            let mut locked_numbers 
                    = numbers.lock().unwrap();
            locked_numbers.push(i);
            println!("{:?}", locked_numbers);
        });
    }

    thread::sleep(Duration::from_secs(1));
}
