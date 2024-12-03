struct Point {
    x: f64,
    y: f64,
}

// 実装のためのブロック。`Point`の持つ関連関数とメソッドを全て定義する。
impl Point {
    // これは特定の型（すなわち Point）に関連した関数なので関連関数
    
    // 関連関数はインスタンスからでなく呼び出すことができる。
    // 以下のようにコンストラクタとして使用されることが多い。
    fn origin() -> Point {
        Point { x: 0.0, y: 0.0 }
    }

    // もう一つ関連関数。引数を2つ取る。
    fn new(x: f64, y: f64) -> Point {
        Point { x: x, y: y }
    }
}

struct Rectangle {
    p1: Point,
    p2: Point,
}

impl Rectangle {
    // こちらはメソッド。`&self`は`self: &Self`の糖衣構文。
    // `Self`は呼び出し元オブジェクトの型。この場合は`Rectangle`。
    fn area(&self) -> f64 {
        // `self`はドット演算子によって構造体のfieldを参照できる。
        let Point { x: x1, y: y1 } = self.p1;
        let Point { x: x2, y: y2 } = self.p2;

        // `abs`は`f64`のメソッドで、呼び出し元の値の絶対値を返す。
        ((x1 - x2) * (y1 - y2)).abs()
    }

    fn perimeter(&self) -> f64 {
        let Point { x: x1, y: y1 } = self.p1;
        let Point { x: x2, y: y2 } = self.p2;

        2.0 * ((x1 - x2).abs() + (y1 - y2).abs())
    }

    // このメソッドは呼び出し元オブジェクトがミュータブルであることを
    // 必要とする。`&mut self`は`self: &mut Self`の糖衣構文である。
    fn translate(&mut self, x: f64, y: f64) {
        self.p1.x += x;
        self.p2.x += x;

        self.p1.y += y;
        self.p2.y += y;
    }
}


fn main() {
    let rectangle = Rectangle {
        // 関連関数はコロンを2つ挟んで呼び出される。
        p1: Point::origin(),
        p2: Point::new(3.0, 4.0),
    };

    // メソッドはドット演算子を用いて呼び出される。
    // 最初の引数`&self`は明示せずに受け渡されていることに注目。つまり
    println!("Rectangle perimeter: {}", rectangle.perimeter());
    println!("Rectangle area: {}", rectangle.area());

    let mut square = Rectangle {
        p1: Point::origin(),
        p2: Point::new(1.0, 1.0),
    };

    // ミュータブルなオブジェクトはミュータブルなメソッドを呼び出せる。
    square.translate(1.0, 1.0);

}