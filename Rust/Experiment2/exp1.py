def main():
    s1 = "Hello, world!"
    if True:
        s2 = s1   
        print(f"{s2}")
    print(f"{s2}") 
if __name__ == "__main__":
    main()
    
    
# s1はmain()終了まで残り続ける
# 同じタイミングで解放できるようにdelする
# Python ではスコープを作ることは可能か
