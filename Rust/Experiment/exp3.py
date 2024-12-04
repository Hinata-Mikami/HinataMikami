class Person():
    def __init__(self, name : str, age : int):
        self.name = name
        self.age = age

class Pair():
    def __init__(self, x : int, y : float):
        self.x = x
        self.y = y


class Point():
    def __init__(self, x : float, y : float):
        self.x = x
        self.y = y

class Rectangle():
    def __init__(self, top_left : Point, bottom_right : Point):
        self.top_left = top_left
        self.bottom_right = bottom_right

def main():
    name = "Peter"
    age = 27
    peter = Person(name, age)
    
    print(peter)
    
    point = Point(x=10.3, y=0.4)
    
    print(f"point coordinates: ({point.x}, {point.y})")
    
    bottom_right = Point(x=5.2, y=point.y)
    print(f"second point: ({bottom_right.x}, {bottom_right.y})")
    
    x, y = point.x, point.y
    del point 
    
    _rectangle = Rectangle(
        top_left = Point(x, y),
        bottom_right = bottom_right
    )
    
    pair = Pair(1, 0.1)
    
    print(f"pair contains {pair.x} and {pair.y}")
    
    integer, decimal = pair.x, pair.y
    print(f"pair contains {integer} and {decimal}")
    
if __name__ == "__main__":
    main()