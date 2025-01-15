from contextlib import nullcontext

def main():
    s1 = "s1"
    
    with nullcontext():
        s11 = s1
        del s1
        print(s11)
        del s11  # del しないと11行目以降も使用可能
    
if __name__ == "__main__":
    main()
    