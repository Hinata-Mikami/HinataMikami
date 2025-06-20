struct Node<'a>{
    next : Option<&'a Node<'a>>,
}

struct Node<'a, 'b>{
    next : Option<&'a Node<'b, 'c>>,
}

fn make_cycle(){
    let mut a = Node{next: None};
    a.next = Some(&a);
}

fn main(){
    make_cycle();
}

