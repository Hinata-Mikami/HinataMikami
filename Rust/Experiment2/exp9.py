import threading
# https://docs.python.org/ja/3.13/library/threading.html

def worker(shared_data):
    print(shared_data)

def main():
    apple = "the same apple"

    threads = []

    for _ in range(10):
        thread = threading.Thread(target=worker, args=(apple,))
        threads.append(thread)
        thread.start()     #targetの実行

    for thread in threads:
        thread.join()      #threadの終了を待つ


if __name__ == "__main__":
    main()
