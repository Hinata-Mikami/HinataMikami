import threading
# https://docs.python.org/ja/3.13/library/threading.html

\

def main():
    apple = "the same apple"

    threads = []

    for _ in range(10):
        def print_value():
            with threading.Lock():
                nonlocal apple
                print(apple)
            
        t = threading.Thread(target=print_value)
        threads.append(t)
        t.start()     #targetの実行

    for thread in threads:
        thread.join()      #threadの終了を待つ


if __name__ == "__main__":
    main()
