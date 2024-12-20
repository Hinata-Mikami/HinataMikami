fn main() {
    let mut vec = vec![1, 2, 3, 4, 5];
    {
        let slice = &mut vec[1..4]; // ベクタの一部を可変スライスとして借用
        for elem in slice.iter_mut() {
            *elem = 0; 
        }
    }
    println!("New array: {:?}", vec); 
}
