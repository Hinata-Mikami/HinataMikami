// An attribute to hide warnings for unused code.
#![allow(dead_code)]

#[derive(Debug)]
struct Person {
    name: String,
    age: u8,
}

// A unit struct
// ユニット
struct Unit;

// A tuple struct
// タプル
struct Pair(i32, f32);

// A struct with two fields
// 2つのフィールドを持つ（クラシックな）構造体
struct Point {
    x: f32,
    y: f32,
}

// Structs can be reused as fields of another struct
// 構造体は他の構造体のフィールドになることができる
#[allow(dead_code)]
struct Rectangle {
    // A rectangle can be specified by where the top left and bottom right
    // corners are in space.
    // 長方形は座標空間上における左上隅と右下隅の位置によって指定できる
    top_left: Point,
    bottom_right: Point,
}

//演習1
fn rect_area(rec:Rectangle) -> f32{
    let x1 = rec.top_left.x;
    let y1 = rec.top_left.y;
    let x2 = rec.bottom_right.x;
    let y2 = rec.bottom_right.y;

    (x2 - x1) * (y2 - y1)
}

//演習2
fn square(p:Point, l:f32) -> Rectangle{
    Rectangle { 
        top_left: Point{x : p.x, y : p.y}, 
        bottom_right: Point{x : (p.x + l), y : (p.y + l)}
    }
}


enum Status {
    Rich,
    Poor,
}

enum Work {
    Civilian,
    Soldier,
}

// enum with implicit discriminator (starts at 0)
// 値を明示しない場合、0から整数が順に入る。
enum Number {
    Zero,
    One,
    Two,
}

// enum with explicit discriminator
// 値を明示する場合
enum Color {
    Red = 0xff0000,
    Green = 0x00ff00,
    Blue = 0x0000ff,
}

use crate::List::*;
enum List {
    // Cons: Tuple struct that wraps an element and a pointer to the next node
    // Cons: これは、要素をラップし、次の要素へのポインタを保持するタプル。
    Cons(u32, Box<List>),
    // Nil: A node that signifies the end of the linked list
    // Nil: 連結リストの終端であることを示すノード
    Nil,
}

// Methods can be attached to an enum
// 列挙型にはメソッドを付与することができる。
impl List {
    // Create an empty list
    // 空リストの作成。
    fn new() -> List {
        // `Nil` has type `List`
        // `Nil` は `List`型を持つ。
        Nil
    }

    // Consume a list, and return the same list with a new element at its front
    // リストを受け取り、その始端に新しい要素を付加したものを返す関数。
    fn prepend(self, elem: u32) -> List {
        // `Cons` also has type List
        // この`Cons` 自体も、その第2要素もどちらもlist型である。
        Cons(elem, Box::new(self))
    }

    // Return the length of the list
    // list の長さを返すメソッド
    fn len(&self) -> u32 {
        // `self` has to be matched, because the behavior of this method
        // depends on the variant of `self`
        // `self` has type `&List`, and `*self` has type `List`, matching on a
        // concrete type `T` is preferred over a match on a reference `&T`
        // after Rust 2018 you can use self here and tail (with no ref) below as well,
        // rust will infer &s and ref tail. 
        // See https://doc.rust-lang.org/edition-guide/rust-2018/ownership-and-lifetimes/default-match-bindings.html
        // このメソッドは、`self`の状態によって振る舞いが
        // 変化するため、matchをする必要がある。
        // `self`の型は`&List`であるので、`*self`は`List`になる。マッチングは
        // リファレンス(`&T`)ではなく実体(`T`)に対して行うのが好ましい。
        match *self {
            // Can't take ownership of the tail, because `self` is borrowed;
            // instead take a reference to the tail
            // `self`をすでに借用しているので、tailの所有権を取ることができない。
            // 代わりに参照を使用する。
            Cons(_, ref tail) => 1 + tail.len(),
            // Base Case: An empty list has zero length
            // 空リストならば長さは0
            Nil => 0
        }
    }

    // Return representation of the list as a (heap allocated) string
    // Listをheap上の文字列として表したものを返すメソッド。
    fn stringify(&self) -> String {
        match *self {
            Cons(head, ref tail) => {
                // `format!` is similar to `print!`, but returns a heap
                // allocated string instead of printing to the console
                // `format!`は`print!`に似ているが、コンソール上に出力
                // する代わりに、heap上の文字列を返す。
                format!("{}, {}", head, tail.stringify())
            },
            Nil => {
                format!("Nil")
            },
        }
    }
}

// Globals are declared outside all other scopes.
// グローバル変数はあらゆるスコープの外で宣言します
static LANGUAGE: &str = "Rust";
const THRESHOLD: i32 = 10;

fn is_big(n: i32) -> bool {
    // Access constant in some function
    // 関数内から定数を参照
    n > THRESHOLD
}

fn main() {
    // Create struct with field init shorthand
    // 構造体をフィールド初期化の簡略記法で生成
    let name = String::from("Peter");
    let age = 27;
    let peter = Person { name, age };

    // Print debug struct
    // 構造体のデバッグ表示を行う
    println!("{:?}", peter);


    // Instantiate a `Point`
    // `Point` のインスタンス化
    let point: Point = Point { x: 10.3, y: 0.4 };

    // Access the fields of the point
    // pointのフィールドにアクセスする。
    println!("point coordinates: ({}, {})", point.x, point.y);

    // Make a new point by using struct update syntax to use the fields of our
    // other one
    // 構造体の更新記法を用いて、別の構造体のフィールドの値を基に
    // 新たなpointを生成
    let bottom_right = Point { x: 5.2, ..point };

    // `bottom_right.y` will be the same as `point.y` because we used that field
    // from `point`
    // `bottom_right.y` の値は `point.y` と同一になるが、
    // これは `point` のフィールドの値を用いて生成したためである
    println!("second point: ({}, {})", bottom_right.x, bottom_right.y);

    // Destructure the point using a `let` binding
    // `let`を使用してpointをデストラクトする。
    let Point { x: left_edge, y: top_edge } = point;

    let _rectangle = Rectangle {
        // struct instantiation is an expression too
        // 構造体の定義とインスタンスの作成を同時に行う
        top_left: Point { x: left_edge, y: top_edge },
        bottom_right: bottom_right,
    };

    // Instantiate a unit struct
    // ユニットをインスタンス化
    let _unit = Unit;

    // Instantiate a tuple struct
    // タプルをインスタンス化
    let pair = Pair(1, 0.1);

    // Access the fields of a tuple struct
    // タプルのフィールドにアクセス
    println!("pair contains {:?} and {:?}", pair.0, pair.1);

    // Destructure a tuple struct
    // タプルをデストラクト
    let Pair(integer, decimal) = pair;

    println!("pair contains {:?} and {:?}", integer, decimal);

    // Explicitly `use` each name so they are available without
    // `use`することで絶対名でなくとも使用可能になる。
    // manual scoping.
    use crate::Status::{Poor, Rich};
    // Automatically `use` each name inside `Work`.
    // `Work`の中の名前をすべて`use`する
    use crate::Work::*;

    // Equivalent to `Status::Poor`.
    // `use`しているため、`Status::Poor`と書いていることに等しい
    let status = Poor;
    // Equivalent to `Work::Civilian`.
    // `Work::Civilian`に等しい
    let work = Civilian;

    match status {
        // Note the lack of scoping because of the explicit `use` above.
        // `use`しているのでスコープを明示していない
        Rich => println!("The rich have lots of money!"),
        Poor => println!("The poor have no money..."),
    }

    match work {
        // Note again the lack of scoping.
        // こちらも同じ
        Civilian => println!("Civilians work!"),
        Soldier  => println!("Soldiers fight!"),
    }

    // `enums` can be cast as integers.
    // 列挙型の中身を整数としてキャストする。
    println!("zero is {}", Number::Zero as i32);
    println!("one is {}", Number::One as i32);

    println!("roses are #{:06x}", Color::Red as i32);
    println!("violets are #{:06x}", Color::Blue as i32);

    // Create an empty linked list
    // 空の連結リストを作成
    let mut list = List::new();

    // Prepend some elements
    // 要素を追加
    list = list.prepend(1);
    list = list.prepend(2);
    list = list.prepend(3);

    // Show the final state of the list
    // 追加後の状態を表示
    println!("linked list has length: {}", list.len());
    println!("{}", list.stringify());

    let n = 16;

    // Access constant in the main thread
    // main 関数の中から定数を参照
    println!("This is {}", LANGUAGE);
    println!("The threshold is {}", THRESHOLD);
    println!("{} is {}", n, if is_big(n) { "big" } else { "small" });

    // Error! Cannot modify a `const`.
    // エラー!`const`は変更できません。
    // THRESHOLD = 5;
    // FIXME ^ Comment out this line
    // FIXME ^ この行をコメントアウトしましょう

}
