def function():
    outer_ref = None
    
    # <scope>
    inner_value = "inner value"
    outer_ref = inner_value
    del outer_ref, inner_value
    # </scope>
        
def main():
    function()    


if __name__ == "__main__":
    main()
