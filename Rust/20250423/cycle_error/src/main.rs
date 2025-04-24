struct Node {
    next: Option<Box<Node>>,
}

fn cycle() {
    let mut a = Box::new(Node { next: None });
    let b = Box::new(Node { next: Some(a) });

    // 循環を作ろうとする
    a.next = Some(b);
}

fn main(){
    cycle()
}
