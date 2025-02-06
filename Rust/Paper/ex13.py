import sys

class Point():
    def __init__(self, x, y):
        self.x = x
        self.y = y

def rc_example():
    a = Point(0, 0)
    b = a
    b.x = 1
    print(f"a.x : {a.x}, b.x : {b.x}")
    print(f"Reference count: {sys.getrefcount(a)-1}") 

def main():
    rc_example()

if __name__ == "__main__":
    main()