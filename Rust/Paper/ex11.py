class Mystruct():
    def __init__(self, value):
        self.value = value
        
def main():
    x1 = Mystruct(1)
    x2 = Mystruct(2) ##
    # <scope>
    x21 = x1
    del x1
    print(x21.value)
    del x21
    # </scope>
    
if __name__ == "__main__":
    main()
    