use std::rc::Rc;
use std::cell::RefCell;

// サイクルを作るための構造体 Node 
struct Node {
    next: Option<Rc<RefCell<Node>>>,
}
// Node のドロップ時にメッセージを表示するための実装
impl Drop for Node {
    fn drop(&mut self) {
        println!("Node dropped");
    }
}

fn make_cycle(){
    // a.next を None にする
    let a = Rc::new(RefCell::new(Node { next: None }));
    // b.next を Some(a.clone()) にする                 
    let b = Rc::new(RefCell::new(Node { next: Some(Rc::clone(&a)) }));  

    // コメントアウトすると 2つの Node は正常にドロップされる
    // a.next == Some(b.clone())
    // RefCell は borrow_mut() で可変参照を取得
    a.borrow_mut().next = Some(Rc::clone(&b));

    println!("function end");
}

fn main() {
    make_cycle();
}
