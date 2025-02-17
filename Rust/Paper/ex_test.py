class Point():
    def __init__(self, x, y):
        self.x = x
        self.y = y
    
    def __del__(self):
        print(f"Dropping Point : x = {self.x}, y = {self.y}")
        
def function():
    p1 = Point(12, 345)
    
    # <scope>
    p11 = Point(0, 0)   # 変数名を変更
    print(f"inside : {p11.x}")
    del p11
    # </scope>
    print(f"outside : {p1.x}")


def main():
    function()
    print("The end of the main function")


if __name__ == '__main__':
    main()