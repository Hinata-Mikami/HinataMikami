class MyString:
    def __init__(self, name):
        self.name = name
    
    def __del__(self):
        print("Dropping MyString")

class MyStr:
    def __init__(self, name):
        self.name = name
    
    def __del__(self):
        print("Dropping MyStr")
        
        
def scope(obj):
    newobj = obj
    print(newobj.name)
        
        
def main():
    s1 = MyString("A")  # 所有権を持つ。所有権が移動されたら使用不可
    s2 = MyStr("B")
    
    # 明示的にスコープは作成できないので，関数として再現
    scope(s1) # 所有権は移動しているはず. 明示的にdel.
    del s1 # または他のオブジェクトに代入されたときに自ら破壊するような構造を作る？
    
    print("L.29")
    
    # またはコンテキストマネージャでスコープを再現
    # https://docs.python.org/ja/3/library/contextlib.html
    from contextlib import nullcontext # exit で何もしない
    with nullcontext():
        s21 = s2
        del s2
        print(s21.name)
        del s21
    
    print("L.40")
    # print(s21.name)   # L38でdel s21しないと s21は利用可能
    
    print("L.43")
    
    s3 = "C"
    s31 = s3
    print(s31)
    del s3
    

if __name__ == "__main__":
    main()
    print("The end of this program")