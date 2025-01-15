import sys
from contextlib import nullcontext

class MyStruct:
    def __init__(self, value):
        self.value = value

    def __del__(self):
        print(f"Dropping MyStruct with value: {self.value}")

def main():

    with nullcontext():
        a = MyStruct(1)
        b = a
        print(f"a: {a.value} b: {b.value}")
        print(f"Reference count: {sys.getrefcount(a)-1}")
        del a, b
        
    print("Exited scope")

if __name__ == "__main__":
    main()
