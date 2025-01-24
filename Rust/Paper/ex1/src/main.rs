struct Mystruct(i32);

fn main() {
    let x1 = Mystruct(1);
    let x2 = x1;

    println!("value of x2 : {}", x2.0);    
}

