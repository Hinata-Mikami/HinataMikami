class Point():
    def __init__(self, x, y):
        self.x = x
        self.y = y
    
    def __del__(self):
        print(f"Dropping : ({self.x}, {self.y})")
        


def main():
    f6()
    print("main end")

def f1():
    p = Point(12, 345)
    print("f1 end")
    
def f2():
    p = Point(12, 345)
    
    q = p
    del p
    
    
def f3():
    p = Point(12, 345)
    if True:
        q = p
        del p
        del q
        
    print("f3 end")

def f4():
    p = Point(12, 345)
    
    g4(p)
    del p
    print("here")
    
def g4(q):
    print("g4 end")
    
def f5():
    p = Point(0, 0)
    
    p = Point(345, 12)
    print(f"p.x = {p.x}")
    print("f5 end")

def f6():
    p = Point(12, 345)
    
    g6(p)
    del p

    
def g6(q):
    q = Point(0, 0)
    print("g6 end")
    
if __name__ == '__main__':
    main()