fn main() {
    let mut array = [1, 2, 3, 4, 5];
    {
        let slice = &mut array[1..3]; // 配列の一部を可変スライスとして借用
        // let slice2 = &mut array[3..4];
        for elem in slice.iter_mut() {
            *elem = 0; 
        }
    }
    println!("New array: {:?}", array); 
}
