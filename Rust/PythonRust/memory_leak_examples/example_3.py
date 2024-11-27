# https://stackoverflow.com/questions/2017381/is-it-possible-to-have-an-actual-memory-leak-in-python-because-of-your-code
import sys
import gc


#メモリリークが発生する例

#グローバル変数のような状態になってしまっている
class Money1:
    name = ''
    symbols = []   # This is the dangerous line here
    print("initialized at Money1") 
        
    def set_name(self, name):
        self.name = name

    def add_symbol(self, symbol):
        self.symbols.append(symbol)

print("Hello") #class自体が文になっていて，

#実行関数(仕様)
def run_1():

    for i in range(10):
        m = Money1()
        m.add_symbol(str(i))

    print(m.symbols)

#メモリリークを回避
#Money2が呼び出されるたびに__init__を実行
class Money2:
    def __init__(self):
        self.name = ''
        self.symbols = []
        # print("initialized at Money2")
        
    def set_name(self, name):
        self.name = name

    def add_symbol(self, symbol):
        self.symbols.append(symbol)

# 実行関数(メモリリークを回避)
def run_2():

    for i in range(10):
        m = Money2()
        m.add_symbol(str(i))

    print(m.symbols)


    

# #実行関数(参照カウントの確認をしようとしたがよくわからず)
# def run_11():
#     m1 = Money1()
#     m1.add_symbol("A")

#     m2 = Money1()
#     m2.add_symbol("B")
    
#     print(m2.symbols)
#     print(sys.getrefcount(m2) - 1)
    

run_1()
# run_11()
run_2()