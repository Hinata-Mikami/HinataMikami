class Mystruct():
    def __init__(self, value):
        self.value = value
        
def main():
    x1 = Mystruct(1)

    # <scope>
    x21 = x1
    del x1
    print(x21.value)
    del x21
    # </scope>
    
    # 実行時間の長いコード
    
if __name__ == "__main__":
    main()