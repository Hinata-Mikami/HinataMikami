def main():
    # Python では定数はサポートされておらず，再代入によって値を変更できる．
    # 慣習として大文字で始めると定数と扱うことが多い
    Immutable = 42
    
    mutable = 21
    mutable = 12
    print(mutable)
    
    # 異なる型の値の代入もできてしまう
    # そもそもオブジェクトidが変わり，別のオブジェクトになっている
    tmp = mutable   #id表示用
    mutable = True
    print(mutable)
    
    print(f"id(tmp) : {id(tmp)}, id(mutable) : {id(mutable)}")
   

    logical: bool = True
    a_float: float = 1.0
    an_integer   = int(5)
    default_float   = 3.0
    default_integer = 7

if __name__ == "__main__":
    main()