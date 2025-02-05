struct Mystruct(i32);

fn main() {
    ownership_move();
}


fn ownership_move(){
    let x1 = Mystruct(1);
    let x2 = x1;

    println!("value of x2 : {}", x2.0);

    // 実行時間の長いコード
}
