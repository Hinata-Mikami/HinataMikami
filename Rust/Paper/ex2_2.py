def main():
    borrowing()
    
def borrowing():
    v1 = [1]
    v2 = v1
    print(v2[0])
    del v2
    print(v1[0])
    
    # 実行時間の長いコード
    
if __name__ == "__main__":
    main()
    