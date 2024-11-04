#![allow(unreachable_code)]

// `allow` required to silence warnings because only
// one variant is used.
// `allow`は値を一つだけ使用したことによる警告を抑えるために存在する。
#[allow(dead_code)]
enum Color {
    // These 3 are specified solely by their name.
    // これら3つの値は名前のみで扱うことができる
    Red,
    Blue,
    Green,
    // These likewise tie `u32` tuples to different names: color models.
    // 以下の値は名前と`u32`のタプルをペアにしている。
    // カラーモデルと呼ばれる。
    RGB(u32, u32, u32),
    HSV(u32, u32, u32),
    HSL(u32, u32, u32),
    CMY(u32, u32, u32),
    CMYK(u32, u32, u32, u32),
}

#[allow(dead_code)]
enum Temperature {
    Celsius(i32),
    Fahrenheit(i32),
}


// A function `age` which returns a `u32`.
// `age`関数は`u32`の値を返す。
fn age() -> u32 {
    15
}

fn some_number() -> Option<u32> {
    Some(42)
}

// Our example enum
// 列挙型の例
enum Foo {
    Bar,
    Baz,
    Qux(u32)
}


fn main() {
    let n = 5;

    if n < 0 {
        print!("{} is negative", n);
    } else if n > 0 {
        print!("{} is positive", n);
    } else {
        print!("{} is zero", n);
    }

    let big_n =
        if n < 10 && n > -10 {
            println!(", and is a small number, increase ten-fold");

            // This expression returns an `i32`.
            // この式は`i32`を返す。
            10 * n
        } else {
            println!(", and is a big number, halve the number");

            // This expression must return an `i32` as well.
            // ここでも返り値の型は`i32`でなくてはならない。
            n / 2
            // TODO ^ Try suppressing this expression with a semicolon.
            // TODO ^ セミコロン(`;`)をつけて、返り値を返さないようにしてみましょう
        };
    //   ^ Don't forget to put a semicolon here! All `let` bindings need it.
    //   ここにセミコロンを付けるのを忘れないように!
    //   `let`による変数束縛の際には必ず必要です!

    println!("{} -> {}", n, big_n);


    let mut count = 0u32;

    println!("Let's count until infinity!");

    // Infinite loop
    // 無限ループ
    loop {
        count += 1;

        if count == 3 {
            println!("three");

            // Skip the rest of this iteration
            // 残りの処理をスキップ
            continue;
        }

        println!("{}", count);

        if count == 5 {
            println!("OK, that's enough");

            // Exit this loop
            // ループを抜ける。
            break;
        }
    }
    'outer: loop {
        println!("Entered the outer loop");

        'inner: loop {
            println!("Entered the inner loop");

            // This would break only the inner loop
            // これは内側のループのみを中断します。
            //break;

            // This breaks the outer loop
            // こちらは外側を中断します
            break 'outer;
        }

        println!("This point will never be reached");
    }

    println!("Exited the outer loop");

    let mut counter = 0;

    let result = loop {
        counter += 1;

        if counter == 10 {
            break counter * 2;
        }
    };

    assert_eq!(result, 20);

    // A counter variable
    // カウンタとなる変数
    let mut n = 1;

    // Loop while `n` is less than 101
    // `n`が101以下である場合のループ
    while n < 101 {
        if n % 15 == 0 {
            println!("fizzbuzz");
        } else if n % 3 == 0 {
            println!("fizz");
        } else if n % 5 == 0 {
            println!("buzz");
        } else {
            println!("{}", n);
        }

        // Increment counter
        // カウンタに1を追加
        n += 1;
    }

        // `n` will take the values: 1, 2, ..., 100 in each iteration
    // `n`は1, 2, ...., 100のそれぞれの値を取ります。
    for n in 1..101 {
        if n % 15 == 0 {
            println!("fizzbuzz");
        } else if n % 3 == 0 {
            println!("fizz");
        } else if n % 5 == 0 {
            println!("buzz");
        } else {
            println!("{}", n);
        }
    }

        // `n` will take the values: 1, 2, ..., 100 in each iteration
    // `n`は1, 2, ...., 100のそれぞれの値を取ります。
    for n in 1..=100 {
        if n % 15 == 0 {
            println!("fizzbuzz");
        } else if n % 3 == 0 {
            println!("fizz");
        } else if n % 5 == 0 {
            println!("buzz");
        } else {
            println!("{}", n);
        }
    }

    let names = vec!["Bob", "Frank", "Ferris"];

    for name in names.iter() {
        match name {
            &"Ferris" => println!("There is a rustacean among us!"),
            // TODO ^ Try deleting the & and matching just "Ferris"
            _ => println!("Hello {}", name),
        }
    }
    
    println!("names: {:?}", names);

    let names = vec!["Bob", "Frank", "Ferris"];

    for name in names.into_iter() {
        match name {
            "Ferris" => println!("There is a rustacean among us!"),
            _ => println!("Hello {}", name),
        }
    }
    
    // println!("names: {:?}", names);
    // FIXME ^ Comment out this line

    let mut names = vec!["Bob", "Frank", "Ferris"];

    for name in names.iter_mut() {
        *name = match name {
            &mut "Ferris" => "There is a rustacean among us!",
            _ => "Hello",
        }
    }

    println!("names: {:?}", names);

    let number = 13;
    // TODO ^ Try different values for `number`

    println!("Tell me about {}", number);
    match number {
        // Match a single value
        // 単一の値とのマッチをチェック
        1 => println!("One!"),
        // Match several values
        // いくつかの値とのマッチをチェック
        2 | 3 | 5 | 7 | 11 => println!("This is a prime"),
        // TODO ^ Try adding 13 to the list of prime values
        // TODO ^ 素数のリストに 13 を加えてみましょう
        // Match an inclusive range
        // 特定の範囲の値とのマッチをチェック
        13..=19 => println!("A teen"),
        // Handle the rest of cases
        // その他の場合の処理
        _ => println!("Ain't special"),
        // TODO ^ Try commenting out this catch-all arm
        // TODO ^ この全てをキャッチするアームをコメントアウトしてみましょう
    }

    let boolean = true;
    // Match is an expression too
    // マッチは式でもある。
    let binary = match boolean {
        // The arms of a match must cover all the possible values
        // マッチは全ての可能な値をカバーしなくてはならない
        false => 0,
        true => 1,
        // TODO ^ Try commenting out one of these arms
        // TODO ^ 試しに片方をコメントアウトしてみましょう。
    };

    println!("{} -> {}", boolean, binary);

    let triple = (0, -2, 3);
    // TODO ^ Try different values for `triple`
    // TODO ^ `triple`に別の値を入れてみましょう。

    println!("Tell me about {:?}", triple);
    // Match can be used to destructure a tuple
    // `match`を用いてタプルをデストラクトしてみましょう。
    match triple {
        // Destructure the second and third elements
        // 2つ目と3つ目の値をデストラクト
        (0, y, z) => println!("First is `0`, `y` is {:?}, and `z` is {:?}", y, z),
        (1, ..)  => println!("First is `1` and the rest doesn't matter"),
        (.., 2)  => println!("last is `2` and the rest doesn't matter"),
        (3, .., 4)  => println!("First is `3`, last is `4`, and the rest doesn't matter"),
        // `..` can be used to ignore the rest of the tuple
        // `..`を使うと、タプルの残りの部分を無視できます。
        _      => println!("It doesn't matter what they are"),
        // `_` means don't bind the value to a variable
        // ここでは`_`は、値を変数に束縛しないことを意味します。
    }
        // Try changing the values in the array, or make it a slice!
    // 配列中の値を変更してみましょう。または、スライスにしてみましょう。
    let array = [1, -2, 6];

    match array {
        // Binds the second and the third elements to the respective variables
        // 2番目と3番目の要素を変数にバインドする。
        [0, second, third] =>
            println!("array[0] = 0, array[1] = {}, array[2] = {}", second, third),

        // Single values can be ignored with _
        // _で値を無視できる。
        [1, _, third] => println!(
            "array[0] = 1, array[2] = {} and array[1] was ignored",
            third
        ),

        // You can also bind some and ignore the rest
        // いくつかの値をバインドして残りを無視できる。
        [-1, second, ..] => println!(
            "array[0] = -1, array[1] = {} and all the other ones were ignored",
            second
        ),
        // The code below would not compile
        // 以下のコードはコンパイルできない。
        // [-1, second] => ...

        // Or store them in another array/slice (the type depends on
        // that of the value that is being matched against)
        // 別の配列やスライスに値を持たせることもできます。
        // (配列かスライスかは、マッチする値の型により異なります)
        [3, second, tail @ ..] => println!(
            "array[0] = 3, array[1] = {} and the other elements were {:?}",
            second, tail
        ),

        // Combining these patterns, we can, for example, bind the first and
        // last values, and store the rest of them in a single array
        // 例えば、これらのパターンを組み合わせて、
        // 最初と最後の値をバインドし、残りの値を配列に持たせることもできます。
        [first, middle @ .., last] => println!(
            "array[0] = {}, middle = {:?}, array[2] = {}",
            first, middle, last
        ),
    }

    let color = Color::RGB(122, 17, 40);
    // TODO ^ Try different variants for `color`
    // TODO ^ `Color`に別の変数を入れてみましょう

    println!("What color is it?");
    // An `enum` can be destructured using a `match`.
    // `enum`は`match`を利用してデストラクトすることができる。
    match color {
        Color::Red   => println!("The color is Red!"),
        Color::Blue  => println!("The color is Blue!"),
        Color::Green => println!("The color is Green!"),
        Color::RGB(r, g, b) =>
            println!("Red: {}, green: {}, and blue: {}!", r, g, b),
        Color::HSV(h, s, v) =>
            println!("Hue: {}, saturation: {}, value: {}!", h, s, v),
        Color::HSL(h, s, l) =>
            println!("Hue: {}, saturation: {}, lightness: {}!", h, s, l),
        Color::CMY(c, m, y) =>
            println!("Cyan: {}, magenta: {}, yellow: {}!", c, m, y),
        Color::CMYK(c, m, y, k) =>
            println!("Cyan: {}, magenta: {}, yellow: {}, key (black): {}!",
                c, m, y, k),
        // Don't need another arm because all variants have been examined
        // 全ての値を列挙したのでその他の場合の処理は必要ない。
    }

        // Assign a reference of type `i32`. The `&` signifies there
    // is a reference being assigned.
    // `i32`型へのリファレンスをアサインする。
    // `&`によってリファレンスであることを明示している。
    let reference = &4;

    match reference {
        // If `reference` is pattern matched against `&val`, it results
        // in a comparison like:
        // 上で定義した`reference`という変数が`&val`とのパターンマッチ
        // に用いられた場合、以下の2つの値が比較されていることになる。
        // `&i32`
        // `&val`
        // ^ We see that if the matching `&`s are dropped, then the `i32`
        // should be assigned to `val`.
        // ^ よって`&`を落とせば、`i32`が`val`にアサインされることがわかる。
        &val => println!("Got a value via destructuring: {:?}", val),
    }

    // To avoid the `&`, you dereference before matching.
    // `&`を使用したくない場合は、マッチングの前にデリファレンスする。
    match *reference {
        val => println!("Got a value via dereferencing: {:?}", val),
    }

    // What if you don't start with a reference? `reference` was a `&`
    // because the right side was already a reference. This is not
    // a reference because the right side is not one.
    // いきなりリファレンスを変数に代入するのではない場合はどうでしょう。
    // 先ほどは右辺値が`&`で始まっていたのでリファレンスでしたが、
    // これは違います。
    let _not_a_reference = 3;

    // Rust provides `ref` for exactly this purpose. It modifies the
    // assignment so that a reference is created for the element; this
    // reference is assigned.
    // このような場合、Rustでは変数束縛時に`ref`を宣言します。
    // 要素のリファレンスが作られて、それが束縛対象になります。
    let ref _is_a_reference = 3;

    // Accordingly, by defining 2 values without references, references
    // can be retrieved via `ref` and `ref mut`.
    // 同様にミュータブルな値の場合`ref mut`を使用することでリファレンスを
    // 取得できます。イミュータブルの場合と合わせてみていきましょう。
    let value = 5;
    let mut mut_value = 6;

    // Use `ref` keyword to create a reference.
    // `ref`を使用してリファレンスを作成。
    match value {
        ref r => println!("Got a reference to a value: {:?}", r),
    }

    // Use `ref mut` similarly.
    // 同様に`ref mut`を使用。
    match mut_value {
        ref mut m => {
            // Got a reference. Gotta dereference it before we can
            // add anything to it.
            // リファレンスを取得、値を変更するためにはデリファレンスする必要がある。
            *m += 10;
            println!("We added 10. `mut_value`: {:?}", m);
        },
    }


    struct Foo {
        x: (u32, u32),
        y: u32,
    }

    // Try changing the values in the struct to see what happens
    // 構造体の中の値を変えて、何が起きるか見てみよう。
    let foo = Foo { x: (1, 2), y: 3 };

    match foo {
        Foo { x: (1, b), y } => println!("First of x is 1, b = {},  y = {} ", b, y),

        // you can destructure structs and rename the variables,
        // the order is not important
        // 構造体をデストラクトして変数をリネーム
        // 順番は重要ではない。
        Foo { y: 2, x: i } => println!("y is 2, i = {:?}", i),

        // and you can also ignore some variables:
        // 一部の変数を無視することもできる。
        Foo { y, .. } => println!("y = {}, we don't care about x", y),
        // this will give an error: pattern does not mention field `x`
        // `x`に言及していないため、以下はエラーになる。
        //Foo { y } => println!("y = {}", y),
    }

    let faa = Foo { x: (1, 2), y: 3 };

    // You do not need a match block to destructure structs:
    let Foo { x : x0, y: y0 } = faa;
    println!("Outside: x0 = {x0:?}, y0 = {y0}");

    let temperature = Temperature::Celsius(35);
    // ^ TODO try different values for `temperature`
    // ^ TODO `temperature`の値を変更してみましょう。

    match temperature {
        Temperature::Celsius(t) if t > 30 => println!("{}C is above 30 Celsius", t),
        // The `if condition` part ^ is a guard
        //                         ^ `if`とそれに続く条件式がガードです。
        Temperature::Celsius(t) => println!("{}C is below 30 Celsius", t),

        Temperature::Fahrenheit(t) if t > 86 => println!("{}F is above 86 Fahrenheit", t),
        Temperature::Fahrenheit(t) => println!("{}F is below 86 Fahrenheit", t),
    }

    let number: u8 = 4;

    match number {
        i if i == 0 => println!("Zero"),
        i if i > 0 => println!("Greater than zero"),
        _ => unreachable!("Should never happen."),
        // TODO ^ uncomment to fix compilation
        // TODO ^ アンコメントしてコンパイルを修正しよう
    }


    println!("Tell me what type of person you are");

    match age() {
        0             => println!("I haven't celebrated my first birthday yet"),
        // Could `match` 1 ..= 12 directly but then what age
        // would the child be? Instead, bind to `n` for the
        // sequence of 1 ..= 12. Now the age can be reported.
        // `1 ... 12`の値を一挙に`match`させることができる。
        // しかしその場合、子供は正確には何歳?
        // マッチした値を`n`にバインディングすることで値を使用できる。
        n @ 1  ..= 12 => println!("I'm a child of age {:?}", n),
        n @ 13 ..= 19 => println!("I'm a teen of age {:?}", n),
        // Nothing bound. Return the result.
        // マッチしなかった場合の処理
        n             => println!("I'm an old person of age {:?}", n),
    }

    match some_number() {
        // Got `Some` variant, match if its value, bound to `n`,
        // is equal to 42.
        // `n`にバインドされた`Some`の値が42に等しいときにマッチ。
        Some(n @ 42) => println!("The Answer: {}!", n),
        // Match any other number.
        // それ以外の数値にマッチ。
        Some(n)      => println!("Not interesting... {}", n),
        // Match anything else (`None` variant).
        // それ以外にマッチ（`None`の値）。
        _            => (),
    }

        // All have type `Option<i32>`
    // 全て`Option<i32>`型
    let number = Some(7);
    let letter: Option<i32> = None;
    let emoticon: Option<i32> = None;

    // The `if let` construct reads: "if `let` destructures `number` into
    // `Some(i)`, evaluate the block (`{}`).
    // `if let`文は以下と同じ意味.
    //
    // もしletがnumberをデストラクトした結果が`Some(i)`になるならば
    // ブロック内(`{}`)を実行する。
    if let Some(i) = number {
        println!("Matched {:?}!", i);
    }

    // If you need to specify a failure, use an else:
    // デストラクトした結果が`Some()`にならない場合の処理を明示したい場合、
    // `else`を使用する。
    if let Some(i) = letter {
        println!("Matched {:?}!", i);
    } else {
        // Destructure failed. Change to the failure case.
        // デストラクト失敗の場合。このブロック内を実行
        println!("Didn't match a number. Let's go with a letter!");
    }

    // Provide an altered failing condition.
    // デストラクト失敗時の処理を更に分岐させることもできる
    let i_like_letters = false;

    if let Some(i) = emoticon {
        println!("Matched {:?}!", i);
    // Destructure failed. Evaluate an `else if` condition to see if the
    // alternate failure branch should be taken:
    // デストラクト失敗。`else if`を評価し、処理をさらに分岐させる。
    } else if i_like_letters {
        println!("Didn't match a number. Let's go with a letter!");
    } else {
        // The condition evaluated false. This branch is the default:
        // 今回は`else if`の評価がfalseなので、このブロック内がデフォルト
        println!("I don't like letters. Let's go with an emoticon :)!");
    }

        // Make `optional` of type `Option<i32>`
    // `Option<i32>`の`optional`を作成
    let mut optional = Some(0);

    // This reads: "while `let` destructures `optional` into
    // `Some(i)`, evaluate the block (`{}`). Else `break`.
    // これは次のように読める。「`let`が`optional`を`Some(i)`にデストラクトしている間は
    // ブロック内(`{}`)を評価せよ。さもなくば`break`せよ。」
    while let Some(i) = optional {
        if i > 9 {
            println!("Greater than 9, quit!");
            optional = None;
        } else {
            println!("`i` is `{:?}`. Try again.", i);
            optional = Some(i + 1);
        }
        // ^ Less rightward drift and doesn't require
        // explicitly handling the failing case.
        // ^ インデントが少なく、デストラクト失敗時の処理を追加で書く必要がない。
    }
    // ^ `if let` had additional optional `else`/`else if`
    // clauses. `while let` does not have these.
    // ^ `if let`の場合は`else`/`else if`句が一つ余分にあったが、
    // `while let`では必要が無い。
}