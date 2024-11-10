//構造体を定義
struct Money1 {
    name: String,
    symbols: Vec<String>,  //VectorでPythonのlistを定義
}

impl Money1 {
    //インスタンスを作成したときに呼び出されるもの(__init__的なもの)．
    fn new() -> Money1 {
        Money1 {
            name: String::new(),
            symbols: Vec::new(),
        }
    }

    fn set_name(&mut self, name: &str) {
        self.name = name.to_string();
    }

    fn add_symbol(&mut self, symbol: &str) {
        self.symbols.push(symbol.to_string());
    }

}

// 実行関数
fn run_1() {
    // 最初のインスタンスを作成
    // for文の中で定義しても，最後のprint時にスコープから抜けてしまうため仕方なく実行
    let mut m = Money1::new();  

    for i in 0..10 {
        m = Money1::new();  // ループのたびに新しいインスタンスを作成
        m.add_symbol(&i.to_string());  // シンボルを追加
    }

    // 最後のインスタンスのsymbolsのみを表示
    println!("{:?}", m.symbols);
}


fn main() {
    run_1();
}
