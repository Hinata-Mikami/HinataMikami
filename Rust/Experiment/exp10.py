GLOBAL = "Hello world!"

def main():
    local = "Hello World"
    # global GLOBAL # あってもなくても変わらない
    GLOBAL = local
    
    outer_ref = None
    
    def scope():
        # nonlocal outer_ref #これの有無で結果が変わる
        inner = "inner value"
        outer_ref = inner
    
    scope()
    print(outer_ref)


if __name__ == "__main__":
    main()
    print(GLOBAL) # local で上書きされている


# nonlocal / global statement
# https://docs.python.org/ja/3/reference/simple_stmts.html#the-nonlocal-statement