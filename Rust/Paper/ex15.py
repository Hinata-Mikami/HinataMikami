class Nil:
    def __del__(self):
        print("Dropping Nil")

class Cons:
    def __init__(self, value, next_node):
        self.value = value
        self.next = next_node

    def __del__(self):
        print(f"Dropping Cons with value: {self.value}")


def list_example():
    a = Cons(5, Nil()) 
    b = Cons(10, a) 

    a.next = b

    del a
    del b

    print("End")
    
def main():
    list_example()

if __name__ == "__main__":
    main()
