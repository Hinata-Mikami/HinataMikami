class Point():
    def __init__(self, x, y):
        self.x = x
        self.y = y
    
    def __del__(self):
        print(f"Dropping Point : x = {self.x}, y = {self.y}")

        
def function():
    p = Point(12, 345)
    q = p                   # Rust の 「可変借用」
    del p                   # p を一旦使用不可に
    # ... q を使用するコード ...
    q = Point(0, 0)
    p = q                   # q のライフタイム終了と同時に p を復活
    del q                   # q のライフタイム終了と同時に del
    # ... q を使用しない実行時間の長いコード ...
    print(f"p.x = {p.x}")
def main():
    function()
    print("main end")

if __name__ == '__main__':
    main()