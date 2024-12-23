fn main() {
    let b = Box::new(5); // ヒープ上にデータを確保
    println!("b = {}", b);
}

// https://doc.rust-jp.rs/rust-by-example-ja/std/box.html
// Box化することの意義