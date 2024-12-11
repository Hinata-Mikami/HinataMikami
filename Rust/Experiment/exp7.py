# 同じ文字列は同じオブジェクトなのか
obj1 = "Hello world!"
obj2 = "Hello world!"
print(f"obj1's id is : {id(obj1)}")
print(f"obj2's id is : {id(obj2)}")

# is はオブジェクトの 同一性　を確認
# https://docs.python.org/3/reference/expressions.html#is-not
# 6.10.3 Identity comparisons
print(obj1 is obj2)

# print(obj1[6])
# obj1[6] = "W" # このような置換は許されない

# 文字列を置換する
obj1.replace("w", "W")

# obj1は書き換わっていない
print(f"{obj1} / {obj2}")

# この時点ではまだ等価
print(obj1 is obj2)

# 再代入を行う
obj1 = obj1.replace("w", "W")

# obj1のidは変更されているが2は不変
print(f"new obj1's id is : {id(obj1)}")
print(f"new obj2's id is : {id(obj2)}")

# obj1は書き換わる
print(f"{obj1} / {obj2}")

# もちろんオブジェクトは非等価
print(obj1 is obj2)


# 同じ定数文字列はすべて等価になるのか？
x = "a"
y = "a"
z = "a"

# True
print((x is y) & (y is z))

def seq_1 (n : int) -> str:
    """
        引数n個分の文字列"1"を生成する関数
        arg n : 1の個数   
    """
    s = ""
    for i in range(n):
        s = s + str(1)
    return s
        
a = seq_1(1)
b = seq_1(1)

print(f"{id(a)} / {id(b)}")

# False
print(a is b)


import sys
a1 = sys.intern(seq_1(100))
b1 = sys.intern(seq_1(100))

# True
# https://docs.python.org/3/library/sys.html#sys.intern 
print(a1 is b1)