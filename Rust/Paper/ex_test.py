class Point():
    def __init__(self, x, y):
        self.x = x
        self.y = y
    
    def __del__(self):
        print(f"Dropping Point : x = {self.x}, y = {self.y}")
        
def function():
    p = Point(12, 345)
    g24(p)
    del p
    
def g24(q : Point):
    q = Point(0, 0)     # Rust ではここで drop
    # ... 実行時間の長いコード ...
    print("The end of g24")


def main():
    function()
    print("The end of the main function")


if __name__ == '__main__':
    main()