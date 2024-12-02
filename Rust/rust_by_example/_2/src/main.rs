use std::mem;
use std::fmt;

// Tuples can be used as function arguments and as return values.
// タプルを関数の引数及び返り値として使用している。
fn reverse(pair: (i32, bool)) -> (bool, i32) {
    // `let` can be used to bind the members of a tuple to variables.
    // `let`でタプルの中の値を別の変数に束縛することができる。
    let (int_param, bool_param) = pair;

    (bool_param, int_param)
}



// This function borrows a slice.
// この関数はスライスを借用する
fn analyze_slice(slice: &[i32]) {
    println!("First element of the slice: {}", slice[0]);
    println!("The slice has {} elements", slice.len());
}

// The following struct is for the activity.
// 以下の構造体は後ほど「演習」で用いる。
#[derive(Debug)]
struct Matrix(f32, f32, f32, f32);

fn transpose (mat : Matrix) -> Matrix {
    let Matrix(a, b, c, d) = mat;

    Matrix(a, c, b, d)
}

impl fmt::Display for Matrix {
    // This trait requires `fmt` with this exact signature.
    // このトレイトは`fmt`が想定通りのシグネチャであることを要求します。
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        // Write strictly the first element into the supplied output
        // stream: `f`. Returns `fmt::Result` which indicates whether the
        // operation succeeded or failed. Note that `write!` uses syntax which
        // is very similar to `println!`.
        // 厳密に最初の要素を、与えられた出力ストリーム `f` に書き込みます。
        // `fmt::Result`を返します。これはオペレーションが成功したか否か
        // を表します。
        // `write!`は`println!`に非常によく似た文法を使用していることに注目。
        write!(f, "({}, {}, {}, {})", self.0, self.1, self.2, self.3)
    }
}

fn main() {
    // Variables can be type annotated.
    // 変数に型を指定
    let logical: bool = true;

    let a_float: f64 = 1.0;  // Regular annotation
                             // 通常の型指定
    let an_integer   = 5i32; // Suffix annotation
                             // サフィックスによる型指定

    // Or a default will be used.
    // サフィックスを指定しない場合、デフォルトを選択
    let default_float   = 3.0; // `f64`
    let default_integer = 7;   // `i32`

    // A type can also be inferred from context.
    // 型を文脈から推定することも可能
    let mut inferred_type = 12; // Type i64 is inferred from another line.
                                // 型 i64 は次行の内容に基づいて推定
    inferred_type = 4294967296i64;

    // A mutable variable's value can be changed.
    // ミュータブルな変数は値を変更できる
    let mut mutable = 12; // Mutable `i32`
                          // ミュータブルな `i32`.
    mutable = 21;

    // Error! The type of a variable can't be changed.
    // エラー！ ミュータブルな変数でも型は不変
    // mutable = true;

    // Variables can be overwritten with shadowing.
    // 変数はシャドーイングによって上書きできる
    let mutable = true;


    // Integer addition
    // 整数の足し算
    println!("1 + 2 = {}", 1u32 + 2);

    // Integer subtraction
    // 整数の引き算
    println!("1 - 2 = {}", 1i32 - 2);
    // TODO ^ Try changing `1i32` to `1u32` to see why the type is important
    // TODO ^ 型が重要であることを実感するため`1i32`を`1u32`に変更してみましょう。

    // Scientific notation
    // 科学的表記
    println!("1e4 is {}, -2.5e-3 is {}", 1e4, -2.5e-3);

    // Short-circuiting boolean logic
    // 単純な論理演算子
    println!("true AND false is {}", true && false);
    println!("true OR false is {}", true || false);
    println!("NOT true is {}", !true);

    // Bitwise operations
    // ビットワイズ演算
    println!("0011 AND 0101 is {:04b}", 0b0011u32 & 0b0101);
    println!("0011 OR 0101 is {:04b}", 0b0011u32 | 0b0101);
    println!("0011 XOR 0101 is {:04b}", 0b0011u32 ^ 0b0101);
    println!("1 << 5 is {}", 1u32 << 5);
    println!("0x80 >> 2 is 0x{:x}", 0x80u32 >> 2);

    // Use underscores to improve readability!
    // 可読性のための`_`（アンダースコア）の使用
    println!("One million is written as {}", 1_000_000u32);  



    // A tuple with a bunch of different types.
    // 様々な型を値に持つタプル
    let long_tuple = (1u8, 2u16, 3u32, 4u64,
                      -1i8, -2i16, -3i32, -4i64,
                      0.1f32, 0.2f64,
                      'a', true);

    // Values can be extracted from the tuple using tuple indexing.
    // インデックスを用いて、タプル内の要素を参照できる。
    println!("Long tuple first value: {}", long_tuple.0);
    println!("Long tuple second value: {}", long_tuple.1);

    // Tuples can be tuple members.
    // タプルはタプルのメンバになれる
    let tuple_of_tuples = ((1u8, 2u16, 2u32), (4u64, -1i8), -2i16);

    // Tuples are printable.
    // タプルはプリント可能である。
    println!("tuple of tuples: {:?}", tuple_of_tuples);

    // But long Tuples (more than 12 elements) cannot be printed.
    // しかし長すぎるタプル(12要素より多いもの)はプリントできない
    //let too_long_tuple = (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13);
    //println!("Too long tuple: {:?}", too_long_tuple);
    // TODO ^ Uncomment the above 2 lines to see the compiler error
    // TODO ^ 上記2行のコメントを外して、コンパイルエラーになることを確認

    let pair = (1, true);
    println!("Pair is {:?}", pair);

    println!("The reversed pair is {:?}", reverse(pair));

    // To create one element tuples, the comma is required to tell them apart
    // from a literal surrounded by parentheses.
    // 要素を1つしか持たないタプルを作成する場合、括弧で囲まれたただのリテラル
    // と区別するため、カンマが必要になる。
    println!("One element tuple: {:?}", (5u32,));
    println!("Just an integer: {:?}", (5u32));

    // Tuples can be destructured to create bindings.
    //タプルを分解して別の変数にそれぞれの値を代入
    let tuple = (1, "hello", 4.5, true);

    let (a, b, c, d) = tuple;
    println!("{:?}, {:?}, {:?}, {:?}", a, b, c, d);

    //演習1
    let matrix = Matrix(1.1, 1.2, 2.1, 2.2);
    println!("{:?}", matrix);
    println!("Display: {}", matrix);

    //演習2
    println!("Matrix:\n{}", matrix);
    println!("Transpose:\n{}", transpose(matrix));

    
    // Fixed-size array (type signature is superfluous).
    // 固定長の配列（型シグネチャは冗長なので、なくても可）
    let xs: [i32; 5] = [1, 2, 3, 4, 5];

    // All elements can be initialized to the same value.
    // すべての要素を0にする場合
    let ys: [i32; 500] = [0; 500];

    // Indexing starts at 0.
    // インデックスは０から
    println!("First element of the array: {}", xs[0]);
    println!("Second element of the array: {}", xs[1]);

    // `len` returns the count of elements in the array.
    // `len`は配列の要素数を返す。
    println!("Number of elements in array: {}", xs.len());

    // Arrays are stack allocated.
    // 配列はスタック上に置かれる
    println!("Array occupies {} bytes", mem::size_of_val(&xs));

    // Arrays can be automatically borrowed as slices.
    // 配列は自動的にスライスとして借用される。
    println!("Borrow the whole array as a slice.");
    analyze_slice(&xs);

    // Slices can point to a section of an array.
    // They are of the form [starting_index..ending_index].
    // `starting_index` is the first position in the slice.
    // `ending_index` is one more than the last position in the slice.
    // スライスは配列の一部を指すことができる。
    // [starting_index..ending_index] の形をとり、
    // `starting_index` はスライスの先頭の位置を表し、
    // `ending_index` はスライスの末尾の1つ先の位置を表す。
    println!("Borrow a section of the array as a slice.");
    analyze_slice(&ys[1 .. 4]);

    // Example of empty slice `&[]`:
    // 空のスライスの例：`&[]`
    let empty_array: [u32; 0] = [];
    assert_eq!(&empty_array, &[]);
    assert_eq!(&empty_array, &[][..]); // Same but more verbose
                                       // 同じ意味だがより冗長な書き方

    // Arrays can be safely accessed using `.get`, which returns an
    // `Option`. This can be matched as shown below, or used with
    // `.expect()` if you would like the program to exit with a nice
    // message instead of happily continue.
    // 配列は、`Option`を返す`.get`で安全にアクセスできます。
    // `Option`は以下のようにマッチさせることもできますし、
    // 運よく処理を続ける代わりに、`.expect()`で素敵なメッセージとともに
    // プログラムを終了することもできます。
    for i in 0..xs.len() + 1 { // Oops, one element too far!
                               // おっと、1要素余分!
        match xs.get(i) {
            Some(xval) => println!("{}: {}", i, xval),
            None => println!("Slow down! {} is too far!", i), 
        }
    }

    // Out of bound indexing on array causes compile time error.
    // 配列のインデックスが範囲外のときはコンパイルエラー
    //println!("{}", xs[5]);
    // Out of bound indexing on slice causes runtime error.
    // スライスのインデックスが範囲外のときはランタイムエラー
    //println!("{}", xs[..][5]);


}