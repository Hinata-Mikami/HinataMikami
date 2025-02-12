def main():
    f11()
    f12()
    f13()
    f131()
    f14()
    f15()
    f16()
    # f21()
    # f22()
    # f23()
    # f24()
    # f25()
    # f26()
    # f33()
    # f34()
    # f35()
    # f37()
    # f43()
    # f44()
    # f45()
    # f46()
    # f53()
    # f54()
    # f55()
    # scope_example()
    # scope_example2()
    # static_const_example()
    # rc_example()
    # list_example()
    # arc_example()
    # string_example()
    
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
    print(f"p.x = {p.x}")
    print(f"q.x = {q.x}")

def f131():
    p = Point(12, 345)
    # ... pを使うコード ...
    q = p
    del p
    # Rust と同様に p は使用不可に
    # ... qを使うコード ...
    print(f"The end of f13. q.x = {q.x}")
    
def f14():
    p = Point(12, 345)
    g14(p)
    
def g14(q : Point):
    # ... qを使うコード ...
    q = None
    print("The end of g14")

def f15():
    p = Point(12, 345)
    q = p if False else Point(345, 12)
    print(f"{p.x}")
    
def f16():
    p = Point(0, 0)
    p = Point(345, 12) # Python では再代入とlet宣言の区別ができない
    p = Point(12, 345)