fn main() {
    let outer_ref;
    {
        let inner_value = String::from("inner value");
        outer_ref = &inner_value; 
    }
}

