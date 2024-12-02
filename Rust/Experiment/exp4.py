LANGUAGE : str= "Rust"
THRESHOLD : int = 10

def is_big(n : int) -> bool:
    n > THRESHOLD
    
def main():
    n = 16
    print(f"This is {LANGUAGE}")
    print(f"THRESHOLD is {THRESHOLD}")
    if is_big(n):
        print(f"{n} is big")
    else:
        print(f"{n} is small")
        
if __name__ == "__main__":
    main()