def main():
    clone_example()
    
   
def clone_example():
    v1 = [1]
    import copy 
    v2 = copy.deepcopy(v1)
    v2[0] += 1
    
    print(f"v1[0] : {v1[0]}") 
    print(f"v2[0] : {v2[0]}")

if __name__ == "__main__":
    main()
