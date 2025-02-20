class Point():
    # コンストラクタ
    def __init__(self, x, y):
        self.x = x
        self.y = y

    # ファイナライザ
    def __del__(self):
        print(f"Dropping : ({self.x}, {self.y})")

        
def function():
    p = Point(12, 345)
    if True:
        q = p
        del p
        del q
        
    print("f3 end")

def main():
    function()
    print("main end")

if __name__ == '__main__':
    main()