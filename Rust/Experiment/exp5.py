class Point():
    def __init__(self, x:float, y:float):
        self.x = x
        self.y = y
        
    def origin():
        return Point(x=0, y=0)
    
    def new(x : float, y : float):
        return Point(x, y)
    
class Rectangle():
    def __init__(self, p1 : Point, p2 : Point):
        self.p1 = p1
        self.p2 = p2
        
    def area(self) -> float:
        x1, y1 = self.p1.x, self.p1.y
        x2, y2 = self.p2.x, self.p2.y
        
        return abs(((x1 - x2) * (y1 - y2)))
    
    def perimeter(self) -> float:
        x1, y1 = self.p1.x, self.p1.y
        x2, y2 = self.p2.x, self.p2.y
        
        return 2.0 * (abs(x1 - x2) + abs(y1 - y2))
    
    def translate(self, x: float, y: float):
        self.p1.x += x
        self.p2.x += x
        self.p1.y += y
        self.p2.y += y
        
def main():
    rectangle = Rectangle(
        p1 = Point.origin(),
        p2 = Point.new(3.0, 4.0)
    )
    
    print(f"Rectangle perimeter: { rectangle.perimeter() }")
    print(f"Rectangle area: { rectangle.area() }")
    
    square = Rectangle (
        p1 = Point.origin(),
        p2 = Point.new(1.0, 1.0)
    )
    
    square.translate(1.0, 1.0)
    
if __name__ == "__main__":
    main()
    
    