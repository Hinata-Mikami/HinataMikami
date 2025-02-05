fn main() {
    mutable_borrowing();
}

fn mutable_borrowing(){
    let mut v1 = vec![1];
    let v2 = &mut v1;
    v2[0] += 1;

    println!("v2[0] : {}", v2[0]);
    println!("v1[0] : {}", v1[0]);

    // 実行時間の長いコード
}