class Mystruct():
    def __init__(self, value):
        self.value = value
        
def scope_example():
    x1 = Mystruct(1)
    x2 = Mystruct(2) 
    
    # <scope>
    x21 = x1
    del x1
    print(x21.value)
    del x21
    # </scope>
    print(f"value of x2 : {x2.value}")
    # 実行時間の長いコード
    
def main():
    scope_example()
    
if __name__ == "__main__":
    main()
    