import copy

def main():
    s1 = ["s1"]

    s2 = copy.deepcopy(s1)
    s2[0] += " : modified"
    print(s1[0]) 
    print(s2[0])

if __name__ == "__main__":
    main()
