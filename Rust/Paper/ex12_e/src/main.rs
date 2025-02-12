// struct Point<'a>{x : &'a i32, y:&'a i32}
struct Point2 {x : String, y :  String}


fn function() {
    // let mut p1 = Point{x : & 0, y : & 0};
    let mut p2 = Point2{x : String::from("Hello"), y : String::from("World")};
    {
        let mut p2_ref = &mut p2.x;
        // let mut p2_ref_y = &mut p2.y;
        // *p2_ref_y = 1;
        // p2.y = 3;
        // *p2_ref = ;
        // let s = p2.x;
        let mut s2 = p2.y;
        // println!("{}", s);
        println!("{}", s2);
        s2.push_str("xxx");
        p2.x.push_str("___");
        // let inside_x = 0;
        // p1.x = & inside_x;
    }
    // println!("{}", p1.x)
}

fn main(){
    function();
}
