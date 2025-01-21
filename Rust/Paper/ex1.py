class Mystruct(int):
    def __init__(self, value):
        self.value = value

def main():
    x1 = Mystruct(1)
    x2 = x1
    del x1
    
    print(f"value of x2 : {x2.value}")

if __name__ == "__main__":
    main()
    