fn main() {
    // 解放されるタイミングの確認用
    check_drop();
    println!("End of the program");
}

// 所有権を持つオブジェクトのメモリがいつ解放されるかは，
// 構造体とそれに対するDropメソッドを定義することで確認できる．
struct MyString(String);

impl Drop for MyString {
    fn drop(&mut self) {
        println!("Dropping MyString: {}", self.0);
    }
}

fn check_drop() {

    let mut s2 = MyString(String::from("_____________"));
    s2 = MyString(String::from("s2")); //s2自身が変わる？ 所有者がいなくなったらdropされる

    let s21 = s2;                   // 所有権移動 s2は以後無効
    println!("s21 : {}", s21.0);

    println!("End.");
}