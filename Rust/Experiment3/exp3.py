class MyString:
    def __init__(self, name):
        self.name = name
    
    def __del__(self):
        print(f"Dropping MyString: {self.name}")
        
def take_ownership(s : MyString):
    print(f"In take_ownership: {s.name}")
    # del s # 不要
    
def borrow_string(s : MyString):
    print(f"In borrow_string: {s.name}")
    

# 動的に実行時にownershipを管理するライブラリ(静的にできない場合) (drop)
def borrow_mut_string(s : MyString):
    tmp = " (modified)"
    s.name = s.name + tmp
    del tmp
    print(f"In borrow_mut_string: {s.name}")
    return s


def main():
    s1 = MyString("A")
    take_ownership(s1)
    del s1 # 必要
    
    s2 = MyString("B")
    borrow_string(s2)
    print(f"main borrow_string: {s2.name}"); 
    
    s3 = MyString("C")
    borrow_mut_string(s3)
    print(f"main borrow_mut_string: {s3.name}"); 
    del s3 # LT終了
    del s2
    
if __name__ == "__main__":
    main()