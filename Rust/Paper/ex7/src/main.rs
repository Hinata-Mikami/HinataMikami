fn main() {
 clone_example();
}

fn clone_example() {
    let v1 = vec![1];
    let mut v2 = v1.clone();
    v2[0] += 1;
    
    println!("v1[0] : {}", v1[0]);
    println!("v2[0] : {}", v2[0]);
}
