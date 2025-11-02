#![feature(register_tool)]
#![register_tool(rr)]
#![feature(custom_inner_attributes)]


#[rr::returns("10")]
fn returns_ten() -> i32 {
    10
}

#[rr::returns("()")]
fn main() {

    let x = returns_ten();
    assert!(x == 20); 

}