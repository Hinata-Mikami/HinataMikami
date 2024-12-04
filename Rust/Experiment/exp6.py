class C():
    def __init__(self, next = None):
        self.next = next
        

def main():
    class1 = C()
    class2 = C()
    
    class1.next = class2
    class2.next = class1
    
if __name__ == "__main__":
    main() 