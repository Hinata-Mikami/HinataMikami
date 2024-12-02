#[allow(unused_variables)]  //warning : unused_variables の抑制

fn main() {

    let immutable = 42;
    // immutable = 0; //Error!

    // ミュータブルな変数は値を変更できる(型は不変)
    let mut mutable = 12;
    mutable = 21;
    println!("{mutable}");

    // 変数はシャドーイングによって上書きできる
    let mutable = true;
    println!("{mutable}");

    //型指定
    let logical: bool = true;
    let a_float: f64 = 1.0;  
    let an_integer   = 5i32; // サフィックスによる型指定
    // サフィックスを指定しない場合、デフォルトを選択
    let default_float   = 3.0; // `f64`
    let default_integer = 7;   // `i32`
}
