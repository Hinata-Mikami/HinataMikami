struct Mystruct(i32);

fn main() {
    let x1 = Mystruct(10);
    take_ownership(x1);

    let x2 = give_ownership();
    println!("value of x2 : {}", x2.0);
    // 実行時間の長いコード
}

fn take_ownership(mystruct : Mystruct){
    println!("value of received struct : {}", mystruct.0);
}

fn give_ownership() -> Mystruct {
    let mystruct = Mystruct(100);
    return mystruct
}
