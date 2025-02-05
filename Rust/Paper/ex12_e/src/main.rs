struct Point<'a>{x : &'a i32, y:&'a i32}

fn function() {
    let mut p1 = Point{x : & 0, y : & 0};
    {
        let inside_x = 0;
        p1.x = & inside_x;
    }
    println!("{}", p1.x)
}

fn main(){
    function();
}
