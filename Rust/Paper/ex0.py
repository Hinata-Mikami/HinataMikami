def factorial(n):
    result = 1
    
    for i in range(1, n + 1):
        result *= i
        
    return result

def main():
    number = 5
    answer = factorial(number)
    
    print(f"factorial({number}) = {answer}")
    
if __name__ == "__main__":
    main()

