class Point():
    def __init__(self, x, y):
        self.x = x
        self.y = y
    
    def __del__(self):
        print(f"Dropping Point : x = {self.x}, y = {self.y}")
        
def function():
    p = Point(12, 345)
    q = p
    # ... q を使うコード ...
    print(f"q.x = {q.x}")
    print(f"p.x = {p.x}")


def main():
    function()
    print("The end of the main function")


if __name__ == '__main__':
    main()