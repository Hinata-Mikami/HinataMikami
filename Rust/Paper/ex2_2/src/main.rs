fn main() {
    borrowing();
}

fn borrowing() {
    let v1 = vec![1];
    let v2 = &v1;
    println!("{}", v2[0]);
    println!("{}", v1[0]);

    // 実行時間の長いコード    
}