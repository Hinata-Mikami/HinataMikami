struct Mystruct(i32);

fn main() {
    let x1 = Mystruct(1);
    let x2 = Mystruct(2);
    {
        let x2 = x1;
        println!("{}", x2.0);
        // 長いコード
    }
    println!("{}", x2.0);
}

