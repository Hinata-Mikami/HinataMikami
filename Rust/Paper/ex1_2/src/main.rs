#[derive(Debug)]
struct Point {
    x : i32,
    y : i32,
}

fn main() {
    let mut p = Point {x : 1, y : 2};

    let mut x_mut = &mut p.x;
    *x_mut = 0;
    let y_ref = &p.y; 

    println!("{:?}", y_ref);    
    // println!("{:?}", p);  Error! 
    println!("{:?}", x_mut);  
    println!("{:?}", p);
}
