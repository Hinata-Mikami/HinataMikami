class Mystruct(int):
    def __init__(self, value):
        self.value = value

def main():
    x1 = Mystruct(10) 
    take_ownership(x1)
    del x1
    
    x2 = give_ownership()
    print(f"value of x2 : {x2.value}")
    # 実行時間の長いコード
    
def take_ownership(mystruct : Mystruct):
    print(f"value of received struct : {mystruct.value}")

def give_ownership() -> Mystruct:
    mystruct = Mystruct(100)
    return mystruct

if __name__ == "__main__":
    main()
    