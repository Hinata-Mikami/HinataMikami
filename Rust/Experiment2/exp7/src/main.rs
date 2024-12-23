fn main() {
    let v1 = vec![1, 2, 3];
    let v2 = v1.clone(); // v1のクローンを作成
    
    println!("v1 = {:?}, v2 = {:?}", v1, v2);
}

//constならクローンせずとも書き換えられるがPythonでは？