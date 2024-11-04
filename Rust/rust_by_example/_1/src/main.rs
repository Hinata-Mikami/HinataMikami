// This is a comment, and is ignored by the compiler.
// You can test this code by clicking the "Run" button over there ->
// or if you prefer to use your keyboard, you can use the "Ctrl + Enter"
// shortcut.
// これはコメントです。コンパイラによって無視されます。
// 右にある「Run」ボタンからこのコードをテストできます。
// キーボードを使いたければ「Ctrl + Enter」もOKです。

// This code is editable, feel free to hack it!
// You can always return to the original code by clicking the "Reset" button ->
// このコードは編集可能です。ぜひハックしてみましょう！
// 「Reset」ボタンでいつでも元のコードに戻すことができます ->

// This is the main function.
// main関数です
fn main() {
    // Statements here are executed when the compiled binary is called.
    // コンパイルされたバイナリが実行されるとこの関数が呼び出されます

    // Print text to the console.
    // コンソールに文字列を出力する
    println!("Hello World!");
    println!("I'm a Rustacean!");


    // In general, the `{}` will be automatically replaced with any
    // arguments. These will be stringified.
    // 一般的に `{} `はどんな引数であろうと自動的に置き換えられます。
    // 例えば以下は文字列に変換されます
    println!("{} days", 31);

    // Positional arguments can be used. Specifying an integer inside `{}`
    // determines which additional argument will be replaced. Arguments start
    // at 0 immediately after the format string.
    // 位置引数を利用できます。
    // `{}`の内側に整数を指定することで、どの引数で置換されるかが決まります。
    // 引数は0から始まります。
    println!("{0}, this is {1}. {1}, this is {0}", "Alice", "Bob");

    // As can named arguments.
    // 名前での指定も可能です。
    println!("{subject} {verb} {object}",
             object="the lazy dog",
             subject="the quick brown fox",
             verb="jumps over");

    // Different formatting can be invoked by specifying the format character
    // after a `:`.
    // `:` のあとにフォーマット型を指定することにより異なるフォーマットも可能です.
    println!("Base 10:               {}",   69420); // 69420
    println!("Base 2 (binary):       {:b}", 69420); // 10000111100101100
    println!("Base 8 (octal):        {:o}", 69420); // 207454
    println!("Base 16 (hexadecimal): {:x}", 69420); // 10f2c
    println!("Base 16 (hexadecimal): {:X}", 69420); // 10F2C

    // You can right-align text with a specified width. This will output
    // "     1". 5 white spaces and a "1".
    // 指定した幅の中に、右寄せで文字列を挿入することができます。
    // 以下の例では"     1". というように、５つの半角空白のあとに"1"が入ります.
    println!("{number:>width$}", number=1, width=6);

    // You can right-justify text with a specified width. This will
    // output "    1". (Four white spaces and a "1", for a total width of 5.)
    // 特定の幅に右詰めすることもできます. このアウトプットは "    1" になります.
    // (4つの空白と"1"で合計幅は5です)
    println!("{number:>5}", number=1);

    // You can pad numbers with extra zeroes,
    // 数字を0埋めすることもできます。
    println!("{number:0>5}", number=1); // 00001
    // and left-adjust by flipping the sign. This will output "10000".
    // 記号を反対にすると左寄せになります。以下は"10000"と出力されます。
    println!("{number:0<5}", number=1); // 10000

    // You can use named arguments in the format specifier by appending a `$`.
    // フォーマット指定子の中に`$`をつけることで名前付き引数を利用できます。
    println!("{number:0>width$}", number=1, width=5);


    // Rust even checks to make sure the correct number of arguments are used.
    // used.
    // 引数の数が正しいかのチェックも行ってくれます。
    println!("My name is {0}, {1} {0}", "Bond", "James");
    // FIXME ^ Add the missing argument: "James"
    // FIXME ^ 不足している引数"James"を追加しましょう。

    // Only types that implement fmt::Display can be formatted with `{}`. User-
    // defined types do not implement fmt::Display by default.
    // `{}`でフォーマットできるのは、fmt::Displayを実装している型のみです。
    // ユーザーが定義した型はデフォルトではfmt::Displayを実装していません。

    #[allow(dead_code)] // disable `dead_code` which warn against unused module
                        // 使用されていないモジュールを警告してくれる`dead_code`を無効化
    struct Structure(i32);

    // This will not compile because `Structure` does not implement
    // fmt::Display.
    // `Structure`はfmt::Displayを実装していないので、
    // 以下はコンパイルできません。
    // println!("This struct `{}` won't print...", Structure(3));
    // TODO ^ Try uncommenting this line
    // TODO ^ この行をアンコメントしてみましょう。

    // For Rust 1.58 and above, you can directly capture the argument from a
    // surrounding variable. Just like the above, this will output
    // "    1", 4 white spaces and a "1".
    // Rust 1.58以上では、周囲の変数から直接引数をキャプチャできます。
    // 上で見たように、以下のコードは4つのスペースと1を、"    1"のように出力します。
    let number: f64 = 1.0;
    let width: usize = 5;
    println!("{number:>width$}");

    let pi: f64 = 3.141592;
    println!("Pi is roughly {number:.3}", number = pi)
}


