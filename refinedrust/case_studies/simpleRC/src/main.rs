#![feature(register_tool)]
#![register_tool(rr)]
#![feature(custom_inner_attributes)]

// sub functions
#[rr::trusted]
#[rr::params("x", "T")]
#[rr::args("(0, x)")]
#[rr::returns("(0, x)")]
fn box_new<T>(t: T) -> Box<T> {
    Box::new(t)
}

#[rr::trusted]
#[rr::params("x", "T")]
#[rr::args("x" @ "T")]
#[rr::exists("l", "c")]
#[rr::returns("l")]
#[rr::ensures(#type "l" : "(c, x)" @ "int i32 * T")] 
fn box_into_raw<T>(b: Box<T>) -> *mut T {
    Box::into_raw(b)
}

#[rr::trusted]
#[rr::params("l", "x")]
#[rr::args("l")]
#[rr::exists("T")]
#[rr::requires(#type "l" : "(0, x)" @ "int i32 * T")] 
#[rr::returns("(0, x)")]
unsafe fn box_from_raw<T>(ptr: *mut T) -> Box<T> {
    Box::from_raw(ptr)
}

// ヒープ領域に確保されるデータ
#[rr::refined_by("(c, x)")]
#[rr::invariant("0 < c")]
struct RcInner<T> {
    #[rr::field("c" @ "int i32")]
    count: usize,
    #[rr::field("x")]
    data: T,
}

// ユーザが使用するスマートポインタ
#[rr::refined_by("l")]
#[rr::exists("c", "x", "T")]
#[rr::invariant(#type "l" : "(c, x)" @ "int i32 * T")]
struct SimpleRC<T> {
    #[rr::field("l")]
    ptr: *mut RcInner<T>,
}

impl<T> SimpleRC<T> {
    
    #[rr::params("x", "T")]
    #[rr::args("x" @ "T")]
    #[rr::exists("l", "c")]
    #[rr::returns("l")]
    // TODO : 事後条件
    #[rr::ensures(#type "l" : "(c, x)" @ "int i32 * T")]
    #[rr::ensures("c = 1")]
    
    fn new(data: T) -> Self {

        let inner = RcInner {
            count: 1,
            data,
        };
        
        let boxed = box_new(inner);

        let ptr = box_into_raw(boxed);

        return SimpleRC { ptr };
    }

    // 現在の参照カウントを取得
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
                let _ = box_from_raw(self.ptr);
            }
        }
    }
}



fn main(){
    let a = SimpleRC::new('a');

    assert!(a.rc_count() == 1); // Rc(a) = 1

    {
        let b = a.clone();
        let c = b.clone(); 
        assert!(a.rc_count() == 3); // Rc(a) = 3

        drop(c); 
        assert!(a.rc_count() == 2); // Rc(a) = 2

    }   // drop(b) が実行される

    assert!(a.rc_count() == 1); // Rc(a) = 1
}   // drop(a) が実行され，a が free される   
