class Point():
    def __init__(self, x, y):
        self.x = x
        self.y = y
    
    def __del__(self):
        print(f"Dropping Point : x = {self.x}, y = {self.y}")

def main():
    f()
    
def f():
    p = Point(0, 1)
    x = [p]
    g(x) 
    del p
    
def g(x):
    p = x[0]
    x[0] = None
    del p
    print("here")
    
if __name__ == '__main__':
    main()