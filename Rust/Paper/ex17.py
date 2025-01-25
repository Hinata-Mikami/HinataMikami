import threading

def main():
        
    apple = "an apple"
    
    threads = []
    
    for i in range(10):
        def update_value():
            with threading.Lock():
                nonlocal apple
                apple = f"thread {i}'s apple"
                print(f"Modified: {apple}")

        t = threading.Thread(target=update_value)
        threads.append(t)
        t.start()
        
    for t in threads:
            t.join()

if __name__ == "__main__":
    main()