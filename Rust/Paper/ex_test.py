class Point():
    def __init__(self, x, y):
        self.x = x
        self.y = y
    
    def __del__(self):
        print(f"Dropping Point : x = {self.x}, y = {self.y}")
        
def function():
    p = Point(12, 345)
    q = p if False else Point(345, 12)
    print("The end of f15")


def main():
    function()
    print("The end of the main function")
    
if __name__ == '__main__':
    main()