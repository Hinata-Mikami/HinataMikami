import sys

def main():
    a = 1
    b = a
    print(f"a : {a}, b : {b}")
    print(f"Reference count: {sys.getrefcount(a)}") 

    # https://docs.python.org/ja/3/library/sys.html
    # Immortal objects have very large refcounts 
    # that do not match the actual number of references 
    # to the object.

if __name__ == "__main__":
    main()