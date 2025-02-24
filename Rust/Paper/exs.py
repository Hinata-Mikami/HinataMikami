def main():
    f11()
    f12()
    f13()
    f131()
    f14()
    f15()
    f16()
    f21()
    f22()
    f23()
    f24()
    f25()
    f26()
    f33()
    f34()
    f35()
    f37()
    f43()
    f44()
    f45()
    f46()
    f53()
    f54()
    f55()
    scope_example0()
    scope_example()
    scope_example2()
    static_const_example()
    rc_example()
    list_example()
    arc_example()
    string_example()
    
class Point():
    def __init__(self, x, y):
        self.x = x
        self.y = y
    
    def __del__(self):
        print(f"Dropping Point : x = {self.x}, y = {self.y}")
        
        
def f11():
    p = Point(12, 345)
    # ... pを使うコード ...

def f12():
    p = Point(12, 345)
    # ... pを使うコード ...
    print(f"p.x = {p.x}")
    
    # ... p を使わないコード ...
    print("The end of f12")
    
def f13():
    p = Point(12, 345)
    # ... pを使うコード ...
    q = p
    # ... qを使うコード ...
    r = p
    
def f131():
    p = Point(12, 345)
    # ... pを使うコード ...
    q = p
    del p
    # ... qを使うコード ...
    # r = p  # Error!
    
def f14():
    p = Point(12, 345)
    # ... p を使うコード ...
    g14(p)
    # ... p を使うコード ...
    
def g14(q : Point):
    # ... qを使うコード ...
    print("The end of g14")
    
def f142():
    p = Point(12, 345)
    # ...
    g142(p)
    del p
    # ...
    print("The end of f142")
    
def g142(q : Point):
    # ...
    print("The end of g142")
    # ここで解放されてほしい
    
def f15():
    p = Point(0, 0)
    p = Point(345, 12) # 禁止できない
    p = Point(12, 345)
    print("The end of f15")
    
def f7():
    p = Point(12, 345)
    # ... p を使うコード ...
    q = p if False else Point(345, 12)
    del p
    print("The end of f7")    
    
def f21():
    p = Point(12, 345)
    # ... pを使うコード ...
    
def f24():
    p = Point(12, 345)
    g24(p)
    del p
    
def g24(q : Point):
    q = Point(0, 0)     # Rust ではここで drop
    # ... 実行時間の長いコード ...
    print("The end of g24")
    
def f25():
    p = Point(0, 0)
    p = Point(12, 345)
    print(f"p.x = {p.x}")
    p = Point(67, 890)
    print("The end of f25")
    
def f31():
    p = Point(12, 345)
    q = p
    # ... p や q を使うコード ...
    print(f"p.x = {p.x}")
    print(f"q.x = {q.x}")

def f32():
    p = Point(12, 345)
    q = p
    r = p
    # ... p や q を使うコード ...
    print(f"q.x = {q.x}")
    print(f"r.x = {r.x}")

def f33():
    p = Point(12, 345)
    q = p
    r = q
    # ...
    print(f"q.x = {q.x}")
  
    
def f36():
    p = Point(12, 345)
    q = p
    # ...
    p = Point(0, 0)
    print(f"p.x = {p.x}")
    print(f"q.x = {q.x}")    
    
def f37():
    p = Point(12, 345)
    p_x = p.x
    p_y = p.y
    del p_x, p_y
    print(f"p.x = {p.x}")

def f41():
    p = Point(12, 345)
    q = p
    # ... q を使うコード ...
    print(f"q.x = {q.x}")
    del q                   # q のライフタイム終了と同時に del
    print(f"p.x = {p.x}")

def f42():
    p = Point(12, 345)
    q = p                  
    r = p                   # 禁止したい
    print(f"p.x = {p.x}")   # 禁止したい
    # ... qを使うコード ...
    print(f"q.x = {q.x}")
    del q                   # q のライフタイム終了と同時に del
    r = p                   # ok

def f421():
    p = Point(12, 345)
    q = p                   # Rust の 「可変借用」
    del p                   # p を一旦使用不可に
    # r = p                 # Error!
    # print(f"p.x = {p.x}") # Error!
    # ... qを使うコード ...
    print(f"q.x = {q.x}")
    p = q                   # q のライフタイム終了と同時に p を復活
    del q                   # q のライフタイム終了と同時に del
    r = p                   # ok
    
def f43():
    p = Point(12, 345)
    q = p                   # Rust の 「可変借用」
    # ... q を使用するコード ...
    q = Point(0, 0)
    del q
    # ... q を使用しない実行時間の長いコード ...
    print(f"p.x = {p.x}")
    
def f431():
    p = Point(12, 345)
    q = p                   # Rust の 「可変借用」
    del p                   # p を一旦使用不可に
    # ... q を使用するコード ...
    q = Point(0, 0)
    p = q                   # q のライフタイム終了と同時に p を復活
    del q                   # q のライフタイム終了と同時に del
    # ... q を使用しない実行時間の長いコード ...
    print(f"p.x = {p.x}")
    

def f460():
    p = Point(12, 345)
    q = p
    q = Point(345, 12)          # Rust では元の値が drop
    # ... q を使用するコード ...
    print(f"q.x = {q.x}")
    del q                       # q と p は別オブジェクト
                                # q のオブジェクトが drop されてしまう
    # ... q を使用しないコード ...
    print(f"p.x = {p.x}")    

def f461():
    p = Point(12, 345)
    q = p                       # 可変借用を一時的な所有権の移動と考える
    del p                       #
    q = Point(345, 12)
    # ... q を使用するコード ...
    print(f"q.x = {q.x}")
    p = q                       # 所有権の返却
    del q                       #
    # ... q を使用しないコード ...
    print(f"p.x = {p.x}")

def f46():
    p = Point(12, 345)
    q = p
    q = Point(345, 12)
    p = Point(0, 0)
    print(f"p.x = {p.x}")
    print(f"q.x = {q.x}")
    del q
    # ... q を使わないコード ...

import copy
def f51():
    p = Point(12, 345)
    q = copy.deepcopy(p)
    # ... p や q を使うコード ...


def f54():
    p = Point(12, 345)
    # ... pを使うコード ...
    g54(copy.deepcopy(p))


def g54(q : Point):
    # ... qを使うコード ...
    pass

def f55():
    p = Point(12, 345)
    # ... pを使うコード ...
    q = p if False else Point(345, 12)
    print(f"p.x = {p.x}")

def scope(p):
    q = p
    print(q.x)
    q = Point(0, 0)     # Rust では元の値が drop
    # 実行時間の長いコード
    print("Inner scope end")

def scope_example0() :
    p = Point(12, 345)
    
    scope(p)
    del p
    
    print("Function end")

    
def scope_example() :
    p = Point(12, 345)
    
    # <scope>
    q = p               
    del p
    # ... q を使用するコード ...
    q = Point(0, 0)     # Rust ではここで drop
    # ... 実行時間の長いコード ...
    print("Inner scope end")
    del q               # スコープ終了時に変数名を使用不可に
    #</scope>
    
    print("Function end")
    
        
def scope_example():
    p = Point(12, 345)
    q = Point(345, 12)
    # <scope>
    q = p
    del p
    print(q.x)
    # 実行時間の長いコード
    del q
    # </scope>
    print("End")
    
def scope_example2():
    p1 = Point(12, 345)
    
    # <scope>
    p11 = Point(0, 0)   # 変数名を変更
    print(f"inside : {p11.x}")
    del p11
    # </scope>
    print(f"outside : {p1.x}")
    
HELLO = "Hello"
WORLD = "World"
COUNTER = 0

def incr_count():
    global COUNTER
    COUNTER += 1

def static_const_example():
    print(f"{HELLO}, {WORLD}!")
    
    incr_count()
    global COUNTER
    print(f"Count: {COUNTER}")
    
import sys
def rc_example():
    a = Point(0, 0)
    b = a
    b.x = 1
    print(f"a.x : {a.x}, b.x : {b.x}")
    print(f"Reference count: {sys.getrefcount(a)-1}")

class Nil:
    def __del__(self):
        print("Dropping Nil")

class Cons:
    def __init__(self, value, next_node):
        self.value = value
        self.next = next_node

    def __del__(self):
        print(f"Dropping Cons with value: {self.value}")


def list_example():
    a = Cons(5, Nil()) 
    b = Cons(10, a) 

    a.next = b

    del a
    del b

    print("Hello world!")    
    
import threading
def arc_example():
    numbers = []
    lock = threading.Lock()  

    def add_number(i):
        with lock:
            numbers.append(i)
            print(f"Modified: {numbers}")

    threads = []
    for i in range(10):
        t = threading.Thread(target=add_number, args=(i,))
        threads.append(t)
        t.start()

    for t in threads:
        t.join()
        
def string_example():
    s1 = "s1"
    
    s2 = s1
    s2 += " : modified"
    print(f"{s2}")
    print(f"{s1}")
    
    
if __name__ == '__main__':
    main()