class Point():
    def __init__(self, x, y):
        self.x = x
        self.y = y
    
    def __del__(self):
        print(f"Dropping Point : x = {self.x}, y = {self.y}")

        
def function():
    s1 = "s1"
    
    s2 = s1
    s2 += " : modified"
    print(f"{s2}")
    print(f"{s1}")
    
def main():
    function()
    print("main end")

if __name__ == '__main__':
    main()