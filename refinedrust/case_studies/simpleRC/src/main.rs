#![feature(register_tool)]
#![register_tool(rr)]
#![feature(custom_inner_attributes)]

// ヒープ領域に確保されるデータ

struct RcInner<T> {
    count: usize,
    data: T,
}

// ユーザが使用するスマートポインタ
struct SimpleRC<T> {
    ptr: *mut RcInner<T>,
}

impl<T> SimpleRC<T> {
    
    fn new(data: T) -> Self{

        // RcInner (data と count) をヒープに確保
        // boxed は RcInner へのポインタ
        let boxed = Box::new(
            RcInner {
                count: 1,
                data,
            }
        );

        // https://doc.rust-lang.org/std/boxed/struct.Box.html#method.into_raw
        // ヒープ上のデータへの raw ポインタを取得して SimpleRC を作成
        // Box はメモリ管理を放棄
        return SimpleRC { ptr: Box::into_raw(boxed) };
    }

    /// 現在の参照カウントを取得
    pub fn rc_count(&self) -> usize {
        return unsafe { (*self.ptr).count }
    }
}

// Clone トレイトの実装
// 参照カウントをインクリメントし，新しい SimpleRC を返す
impl<T> Clone for SimpleRC<T> {
    fn clone(&self) -> Self {
        unsafe {
            (*self.ptr).count += 1;
        }
        return SimpleRC { ptr: self.ptr };
    }
}

// Drop トレイトの実装
// 参照カウントをデクリメントし，0 になったらデータ管理を Box に戻す
impl<T> Drop for SimpleRC<T> {
    fn drop(&mut self) {
        unsafe {
            (*self.ptr).count -= 1;

            if (*self.ptr).count == 0 {
                println!("Dropping data");
                // https://doc.rust-lang.org/std/boxed/struct.Box.html#method.from_raw
                // raw ポインタを Box に戻す
                // 所有者がいないため Box の Drop がメモリを解放してくれる
                let _ = Box::from_raw(self.ptr);
            }
        }
    }
}



fn main(){
    let a = SimpleRC::new("a"); // a (RC管理) を作る

    assert!(a.rc_count() == 1); // Rc(a) = 1

    {
        let b = a.clone();      // b (a のクローン) を作る 
        let c = b.clone();      // c (b のクローン) を作る  

        assert!(a.rc_count() == 3); // Rc(a) = 3

        drop(c);    // c を破棄  
        assert!(a.rc_count() == 2); // Rc(a) = 2

    }   // drop(b) が実行される

    assert!(a.rc_count() == 1); // Rc(a) = 1

}   // drop(a) が実行され，a が free される   
