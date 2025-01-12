fn main() {
    // 解放されるタイミングの確認用
    check_drop();
    println!("Check if s2 is dropped before this comment.");
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

    let s2 = MyString(String::from("s2"));

    let s21 = s2;                   // 所有権移動 s2は以後無効
    println!("s21 : {}", s21.0);

    println!("Check if s2 is dropped after this comment.");
}                                   // LT終了によるメモリ解放 : s21