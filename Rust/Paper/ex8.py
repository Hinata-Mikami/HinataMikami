HELLO = "Hello"
WORLD = "World"
COUNTER = 0

def incr_count():
    global COUNTER
    COUNTER += 1

def function():
    print(f"{HELLO}, {WORLD}!")
    
    incr_count()
    global COUNTER
    print(f"Count: {COUNTER}")
    
def main():
    function()
    
    
if __name__ == "__main__":
    main()