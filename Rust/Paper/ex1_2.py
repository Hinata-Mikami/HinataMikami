class Mystruct():
    def __init__(self, vec1 : list, vec2 : list):
        self.vec1 = vec1
        self.vec2 = vec2

def main():
    mystruct = Mystruct(
        vec1 = [1, 2, 3],
        vec2 = [4, 5, 6]
    )
    
    vec11 = mystruct.vec1
    vec11 = [0, 0, 0]
    print(mystruct)
    print(mystruct.vec1)
    print(mystruct.vec2)
    
if __name__ == "__main__":
    main()