struct Mystruct(i32);

fn scope_example2() {
    let x1 = Mystruct(1);
    let x2 = Mystruct(2);
    {
        let x2 = x1;
        println!("{}", x2.0);
        
    }
    println!("{}", x2.0);
    // 実行時間の長いコード
}


fn main(){
    scope_example();
}
