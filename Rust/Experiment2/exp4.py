def main():
    array = [1, 2, 3, 4, 5] 
    slice = array[1:4]
    for i in range(len(slice)):
        slice[i] = 0

    array[1:4] = slice
    print(f"New array: {array}")
    
if __name__ == "__main__":
    main()
    
# スライスは使えない.
# 元の配列をコピーして対応