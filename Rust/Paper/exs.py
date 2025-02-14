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
    print(f"q.x = {q.x}")
    print(f"p.x = {p.x}")
    
def f131():
    p = Point(12, 345)
    # ... pを使うコード ...
    q = p
    del p
    # ... qを使うコード ...
    print(f"q.x = {q.x}")
    # print(f"p.x = {p.x}") # Error
    
    
def f14():
    p = Point(12, 345)
    # ... p を使うコード ...
    g14(p)
    # ... p を使うコード ...
    
def g14(q : Point):
    # ... qを使うコード ...
    del q  # メモリ解放されない
    print("The end of g14")
    
def f142():
    p = Point(12, 345)
    # ...
    g142(p)
    print("here")
    del p
    # ...
    print("The end of f142")
    
def g142(q : Point):
    # ...
    q = Point(0, 0)
    # ...
    print("The end of g142")
    

def f15():
    p = Point(12, 345)
    q = p if False else Point(345, 12)
    print("The end of f15")
    
def f16():
    p = Point(0, 0)
    p = Point(345, 12) # Python では再代入とlet宣言の区別ができない
    p = Point(12, 345)
    
def f21():
    p = Point(12, 345)
    
def f22():
    p = Point(12, 345)
    # ... pを使うコード ...
    print("here")
    # ... pを使用しないコード ...
    
def f23():
    p = Point(12, 345)
    # ... pを使うコード ...
    q = p
    del p
    # ... q を使うコード ... 
    
def f24():
    p = Point(12, 345)
    g24(p)
    del p
    
def g24(q : Point):
    # ... qを使うコード ...
    q = Point(0, 0)
    print("The end of g24")
    
def f25():
    p = Point(12, 345)
    # ... pを使うコード ...
    q = p if False else Point(345, 12)
    del p
    
def f26():
    p = Point(12, 345)
    p = Point(345, 12)
    
def f33():
    p = Point(12, 345)
    # ... pを使うコード ...
    q = p
    # ... qを使うコード ...
    
def f34():
    p = Point(12, 345)
    # ... pを使うコード ...
    g34(p)
    del p
    
def g34(q : Point):
    # ... qを使うコード ...
    print(f"q.x = {q.x}")
    
def f35():
    p = Point(12, 345)
    # ... pを使うコード ...
    q = p if False else Point(345, 12)
    print(f"p.x = {p.x}")
    
def f37():
    p = Point(12, 345)
    p_x = p.x
    p_y = p.y
    del p_x, p_y
    print(f"p.x = {p.x}")
    
def f43():
    p = Point(12, 345)
    # ... pを使うコード ...
    q = p
    # ... qを使うコード
    
def f44():
    p = Point(12, 345)
    # ... pを使うコード ...
    g44(p)


def g44(q : Point):
    # ... qを使うコード ...
    pass

def f45():
    p = Point(12, 345)
    # ... pを使うコード ...
    q = p if False else Point(345, 12)
    print(f"{p.x}" ) 


def f46():
    p = Point(12, 345)
    q = p
    q = Point(345, 12)

import copy

def f53():
    p = Point(12, 345)
    # ... pを使うコード ...
    q = copy.deepcopy(p)
    # ... qを使うコード ...


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

def scope_example0() :
    p = Point(12, 345)
    
    scope(p)
    del p
    
    # 実行時間の長いコード
    
def scope_example():
    p = Point(12, 345)

    # <scope>
    q = p
    del p
    print(q.x)
    del q
    # 実行時間の長いコード 
    # </scope>
    
def scope_example2():
    p1 = Point(12, 345)
    p2 = Point(345, 12)
    
    # <scope>
    p21 = p1
    del p1
    print(p21.x)
    del p21
    # 実行時間の長いコード
    # </scope>
    print(f"value of x2 : {p2.x}")
    
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