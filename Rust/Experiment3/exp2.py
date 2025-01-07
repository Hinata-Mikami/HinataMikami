HELLO = "Hello, world!"
LANG = "Rust"
COUNTER = 0

def incr_count():
    global COUNTER
    COUNTER += 1


def main():
    print(f"{HELLO} {LANG}")
    
    global COUNTER
    COUNTER += 1
    incr_count()
    print(f"Count: {COUNTER}")
    
    
if __name__ == "__main__":
    main()