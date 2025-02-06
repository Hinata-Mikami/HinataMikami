import threading
import time

def arc_example():
    numbers = []
    lock = threading.Lock()  

    def add_number(i):
        with lock:
            numbers.append(i)
            print(f"Modified: {numbers}")

    threads = []
    for i in range(10):
        t = threading.Thread(target=add_number, args=(i,))
        threads.append(t)
        t.start()

    for t in threads:
        t.join()

def main():
    arc_example()

if __name__ == "__main__":
    main()
