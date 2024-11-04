// Suppress all warnings from casts which overflow.
// オーバーフローを起こすようなキャストによる警告を無視する。
#![allow(overflowing_literals)]

// `NanoSecond`, `Inch`, and `U64` are new names for `u64`.
// `NanoSecond` `Inch` `U64` を `u64`の別名として使用する。
type NanoSecond = u64;
type Inch = u64;
type U64 = u64;

// Use an attribute to silence warning.
// 警告を抑えるアトリビュートを使用。
#[allow(non_camel_case_types)]
type u64_t = u64;
// TODO ^ Try removing the attribute
// TODO ^ アトリビュートを使用しない場合、どうなるか見てみましょう。

fn main() {
    let decimal = 65.4321_f32;

    // Error! No implicit conversion
    // エラー！ 暗黙的な型変換はできない。
    // let integer: u8 = decimal;
    // FIXME ^ Comment out this line
    // FIXME ^ この行をコメントアウトしましょう。

    // Explicit conversion
    // 明示的な型変換
    let integer = decimal as u8;
    let character = integer as char;

    // Error! There are limitations in conversion rules.
    // A float cannot be directly converted to a char.
    // エラー！ 変換ルールには制限があります。
    // 浮動小数点数を文字に直接変換することはできません。
    // let character = decimal as char;
    // FIXME ^ Comment out this line
    // FIXME ^ この行をコメントアウトしましょう。

    println!("Casting: {} -> {} -> {}", decimal, integer, character);

    // when casting any value to an unsigned type, T,
    // T::MAX + 1 is added or subtracted until the value
    // fits into the new type
    // 何らかの値を符号なしの型（仮にTとする）へキャストすると
    // 値がTに収まるまで、T::MAX + 1 が加算あるいは減算される。

    // 1000 already fits in a u16
    // 1000 はすでにu16に収まっているため変化しない。
    println!("1000 as a u16 is: {}", 1000 as u16);

    // 1000 - 256 - 256 - 256 = 232
    // Under the hood, the first 8 least significant bits (LSB) are kept,
    // while the rest towards the most significant bit (MSB) get truncated.
    // 水面下では最下位ビットから8bitが使用され、残りの上位ビットが圧縮される形になる。
    println!("1000 as a u8 is : {}", 1000 as u8);
    // -1 + 256 = 255
    println!("  -1 as a u8 is : {}", (-1i8) as u8);

    // For positive numbers, this is the same as the modulus
    // 正の数では、これは剰余と同じです。
    println!("1000 mod 256 is : {}", 1000 % 256);

    // When casting to a signed type, the (bitwise) result is the same as
    // first casting to the corresponding unsigned type. If the most significant
    // bit of that value is 1, then the value is negative.
    // 符号付きの型にキャストする場合、結果は以下の2つを行った場合に等しい
    // 1. 対応する符号なしの型にキャストする。
    // 2. 2の補数(two's complement)をとる

    // Unless it already fits, of course.
    // すでに収まっている場合はそのままです。
    println!(" 128 as a i16 is: {}", 128 as i16);

    // 128 as u8 -> 128, whose value in 8-bit two's complement representation is:
    // 128をu8にキャストすると128となる。128の8ビットにおける補数は -128
    println!(" 128 as a i8 is : {}", 128 as i8);

    // repeating the example above
    // 上で示した例から
    // 1000 as u8 -> 232
    println!("1000 as a u8 is : {}", 1000 as u8);
    // and the value of 232 in 8-bit two's complement representation is -24
    // が成り立つ。232の8ビットにおける補数は -24
    println!(" 232 as a i8 is : {}", 232 as i8);

    // Since Rust 1.45, the `as` keyword performs a *saturating cast*
    // when casting from float to int. If the floating point value exceeds
    // the upper bound or is less than the lower bound, the returned value
    // will be equal to the bound crossed.
    // Rust 1.45以降、浮動小数点数を整数にキャストするとき、
    // `as`キーワードが *飽和的キャスト* を行います。
    // 浮動小数点数の値が上限を超えたり下限を下回ったりする場合は、
    // 戻り値は越えられた境界の値となります。

    // 300.0 as u8 is 255
    println!(" 300.0 as u8 is : {}", 300.0_f32 as u8);
    // -100.0 as u8 is 0
    println!("-100.0 as u8 is : {}", -100.0_f32 as u8);
    // nan as u8 is 0
    println!("   nan as u8 is : {}", f32::NAN as u8);

    // This behavior incurs a small runtime cost and can be avoided
    // with unsafe methods, however the results might overflow and
    // return **unsound values**. Use these methods wisely:
    // この挙動は実行時にややコストがかかるため、安全でない方法で回避できます。
    // ただし、結果はオーバーフローしたり *不正確な値* を返す場合があります。
    // この方法は賢く使いましょう:
    unsafe {
        // 300.0 as u8 is 44
        println!(" 300.0 as u8 is : {}", 300.0_f32.to_int_unchecked::<u8>());
        // -100.0 as u8 is 156
        println!("-100.0 as u8 is : {}", (-100.0_f32).to_int_unchecked::<u8>());
        // nan as u8 is 0
        println!("   nan as u8 is : {}", f32::NAN.to_int_unchecked::<u8>());
    }

    // Suffixed literals, their types are known at initialization
    // サフィックスを指定したリテラル。型は初期化とともに確定する。
    let x = 1u8;
    let y = 2u32;
    let z = 3f32;

    // Unsuffixed literals, their types depend on how they are used
    // サフィックスを指定しないリテラル。型は使用方法に依存する。
    let i = 1;
    let f = 1.0;

    // `size_of_val` returns the size of a variable in bytes
    // `size_of_val` 関数は変数のサイズをバイトで返す。
    println!("size of `x` in bytes: {}", std::mem::size_of_val(&x));
    println!("size of `y` in bytes: {}", std::mem::size_of_val(&y));
    println!("size of `z` in bytes: {}", std::mem::size_of_val(&z));
    println!("size of `i` in bytes: {}", std::mem::size_of_val(&i));
    println!("size of `f` in bytes: {}", std::mem::size_of_val(&f));

        // Because of the annotation, the compiler knows that `elem` has type u8.
    // アノテーションのおかげで、コンパイラは`elem`がu8型であることがわかる。
    let elem = 5u8;

    // Create an empty vector (a growable array).
    // 空のベクトル（可変長の配列）を生成
    let mut vec = Vec::new();
    // At this point the compiler doesn't know the exact type of `vec`, it
    // just knows that it's a vector of something (`Vec<_>`).
    // この時点でコンパイラは`vec`の型を知らず、
    // 単に何らかの値のベクトル(`Vec<_>`)であるということだけを把握している。

    // Insert `elem` in the vector.
    // `elem`をベクトルに挿入
    vec.push(elem);
    // Aha! Now the compiler knows that `vec` is a vector of `u8`s (`Vec<u8>`)
    // TODO ^ Try commenting out the `vec.push(elem)` line
    // よし！ これでコンパイラは`vec`が`u8`のベクトル(`Vec<u8>`)であることを把握する。
    // TODO ^ 上の `vec.push(elem)` をコメントアウトしてみましょう。

    println!("{:?}", vec);

    // `NanoSecond` = `Inch` = `U64` = `u64`.
    let nanoseconds: NanoSecond = 5 as U64;
    let inches: Inch = 2 as U64;

    // Note that type aliases *don't* provide any extra type safety, because
    // aliases are *not* new types
    // 型のエイリアスは、元の型をより型安全にしてくれる **わけではない** ことに注意しましょう。
    // なぜならば、エイリアスは新たな型を定義している **わけではない** からです。
    println!("{} nanoseconds + {} inches = {} unit?",
             nanoseconds,
             inches,
             nanoseconds + inches);

}