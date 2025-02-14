class Point():
    def __init__(self, x, y):
        self.x = x
        self.y = y
    
    def __del__(self):
        print(f"Dropping Point : x = {self.x}, y = {self.y}")
        
def function():
    p = Point(12, 345)
    g142(p)
    del p
    print("The end of f142")
    
    
def g142(q : Point):
    # ... qを使うコード ...
    q = Point(0, 0)
    # ... 実行時間の長いコード ...
    print("The end of g142")


def main():
    function()
    print("The end of the main function")
    
if __name__ == '__main__':
    main()