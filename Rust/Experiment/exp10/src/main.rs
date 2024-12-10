static mut GLOBAL : &str = "Hello world!";

fn main() {
    let local = String::from("Hello World!");
    // GLOBAL = &local; 
    // error[E0133]: use of mutable static is unsafe 
    //               and requires unsafe function or block
    // error[E0597]: `local` does not live long enough

    let outer_ref;
    {
        let inner = String::from("inner value");
        outer_ref = &inner; 
    }
    // println!("{}", outer_ref); 
    // error[E0597]: `inner` does not live long enough
}
