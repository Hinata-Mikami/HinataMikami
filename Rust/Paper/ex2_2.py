def main():
    v1 = [1]
    
    v2 = v1
    print(v2[0])
    del v2
    print(v1[0])
    
    v1 = [0, 1]
    print(v1[0])
    
if __name__ == "__main__":
    main()
    