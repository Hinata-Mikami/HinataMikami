// #[derive(Debug)]
struct MyStruct {
    vec1: Vec<i32>,
    vec2: Vec<i32>,
}

fn main() {
    let mut mystruct = MyStruct {
        vec1: vec![1, 2, 3],
        vec2: vec![4, 5, 6],
    };

    let mut vec11 = mystruct.vec1;
    vec11 = vec![0, 0, 0];
    // println!("{:?}", mystruct);       Error!
    // println!("{:?}", mystruct.vec21); Error!
    println!("{:?}", mystruct.vec2);  
}
