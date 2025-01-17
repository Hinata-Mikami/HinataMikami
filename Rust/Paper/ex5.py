def main():
    s1 = ["s1"]

    s2 = s1
    s2[0] += " : modified"
    print(s2[0]) 
    print(s1[0])

if __name__ == "__main__":
    main()

