import threading
import time

def worker(shared_data):
    # 各スレッドが共有データを参照
    print(shared_data)

def main():
    # このデータはスレッド間で共有されます
    apple = "the same apple"

    threads = []

    for _ in range(10):
        thread = threading.Thread(target=worker, args=(apple,))
        threads.append(thread)
        thread.start()

    for thread in threads:
        thread.join()


if __name__ == "__main__":
    main()
