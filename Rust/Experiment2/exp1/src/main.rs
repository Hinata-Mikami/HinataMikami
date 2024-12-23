fn main() {
    let s = "Hello, world";

    let s1 = String::from("Hello, world!");
    {
        let s2 = s1; // 所有権が移動 s1 
        println!("{}", s2);
    }                       // s2解放
    // println!("{}", s2); 当然不可

    //ここで無限ループするとs2は解放されないのか？
}

//文字列以外にしたとすると 
// let s3 = Vec! 