from contextlib import nullcontext

def main():
    
    outer_ref = None
    
    with nullcontext():
        inner_value = "inner value"
        outer_ref = inner_value
        del outer_ref, inner_value
        
        


if __name__ == "__main__":
    main()
