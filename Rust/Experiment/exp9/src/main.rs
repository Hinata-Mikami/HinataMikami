struct MyStruct {
    value: String,
}


fn main() {
    let my_struct = MyStruct {
        value: String::from("Hello world!"),
    };

    let val1 = my_struct.value; // 所有権が移動
    // let val2 = my_struct.value; // コンパイルエラー: 所有権がすでに移動している

    let my_struct2 = MyStruct {
        value: String::from("Hello world!"),
    };
    let val3 = &my_struct2.value; // 参照の借用
    let val4 = &my_struct2.value; // 再び借用可能
    println!("{}, {}", val3, val4);


    let mut val5 = &my_struct2.value;
    let tmp = String::from("Hello World!");
    val5 = &tmp;

    println!("{}, {}, {}", val3, val4, val5);

    // btw, 
    // let mut val5 = &my_struct2.value;
    // val5 = &String::from("Hello World!");
    // println!("{}, {}, {}", val3, val4, val5);
    // は，エラーになった.
    // 30行目にval5で使われているのに29行目でfreeされてしまっている

    // let val6 = &mut my_struct2.value; // コンパイルエラー：mutとして借用することはできない
    let mut my_mut_struct = MyStruct {
        value: String::from("Hello world!"),
    };
    let val6 = &mut my_mut_struct.value;

}
