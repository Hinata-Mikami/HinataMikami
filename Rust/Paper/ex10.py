def scope(s1):
    s11 = s1
    print(s11)

def main() :
    s1 = "s1"
    
    scope(s1)
    del s1

if __name__ == "__main__":
    main()
    
    
    