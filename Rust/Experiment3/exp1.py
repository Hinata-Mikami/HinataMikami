# RustのString型に相当。ヒープに保存，所有権を持つ
class MyString:
    def __init__(self, name):
        self.name = name
    
    def __del__(self):
        print("Dropping MyString")

# Rustのstr型に相当。&strはスタックに保存，ヒープ先頭要素への参照。
class MyStr:
    def __init__(self, name):
        self.name = name
    
    def __del__(self):
        print("Dropping MyStr")
        
def assignment(obj):
    newobj = obj
    print(newobj.name)
        
def main():
    s1 = MyString("A")  # 所有権を持つ。所有権が移動されたら使用不可
    s2 = MyStr("B")
    
    assignment(s1) # 所有権は移動しているはず. 明示的にdel.
    del s1 # または他のオブジェクトに代入されたときに自ら破壊するような構造を作る？
    
    print("L.28")
    
    assignment(s2)
    del s2
    
    print("L.33")
    
    s3 = "C"
    s31 = s3
    print(s31)
    

if __name__ == "__main__":
    main()
    print("The end of this program")