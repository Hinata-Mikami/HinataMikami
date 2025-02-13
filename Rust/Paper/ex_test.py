class Point():
    def __init__(self, x, y):
        self.x = x
        self.y = y
    
    def __del__(self):
        print(f"Dropping Point : x = {self.x}, y = {self.y}")
        
def function():
    pass


def main():
    function()
    
if __name__ == '__main__':
    main()