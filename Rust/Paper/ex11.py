class Mystruct():
    def __init__(self, value):
        self.value = value
        
def main():
    x1 = Mystruct(1)
    
    # <scope>
    x2 = x1
    del x1
    print(x2.value)
    del x2
    # </scope>
    
if __name__ == "__main__":
    main()
    