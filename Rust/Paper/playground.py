class Point():
    def __init__(self, x, y):
        self.x = x
        self.y = y
    
    def __del__(self):
        print(f"Dropping Point : x = {self.x}, y = {self.y}")

def main():
    print("start")
    p = Point(12, 345)
    del p   # ファイナライザが呼ばれる

    p1 = Point(67, 890)
    p2 = p1
    del p1  # ファイナライザは呼ばれない
    print("end")
    
if __name__ == '__main__':
    main()