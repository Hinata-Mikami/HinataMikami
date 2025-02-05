class Mystruct():
    def __init__(self, value):
        self.value = value

def scope(x1):
    x2 = x1
    print(x2.value)

def scope_example() :
    x1 = Mystruct(1)
    
    scope(x1)
    del x1
    
    # 実行時間の長いコード
    
def main():
    scope_example()

if __name__ == "__main__":
    main()
    
    
    