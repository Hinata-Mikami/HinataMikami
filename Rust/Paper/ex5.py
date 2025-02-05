def main():
    mutable_borrowing()
    
def mutable_borrowing():
    v1 = [1]
    v2 = v1
    v2[0] += 1
    
    print(f"v2[0] : {v2[0]}")
    del v2 
    print(f"v1[0] : {v1[0]}")
    
    # 実行時間の長いコード    


if __name__ == "__main__":
    main()

