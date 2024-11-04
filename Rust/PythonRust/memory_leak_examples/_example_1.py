# 参考(2024/11/04)
# https://yusekita.com/detail/78d1f7f8-dd9e-4b04-b9d6-f26e2e0d2a0e/

class ClassB:

    def __init__(self):
        self.__values = {}

    @property
    def values(self):
        return self.__values

    def add(self, instance, name):
        self.__values[instance] = name
        # {Key:instance , Value:name} 
        # 実行するとClassAのインスタンスを保持する -> 循環参照となる（GCにより解放されない）


class ClassA:
    class_b = ClassB()

    def add(self, name):
        self.class_b.add(self, name) #ClassBのaddにClassAのインスタンスを渡す


def run1():
    class_a = ClassA()  # ClassA のインスタンス
                        # 本当はここでGCされてほしいがGCされず既存のclass_aが残ってしまっている
    class_a.add('class A')
    print('values:', dict(class_a.class_b.values))



# 修正
from weakref import WeakKeyDictionary

class ClassD:

    def __init__(self):
        self.__values = WeakKeyDictionary()

    @property
    def values(self):
        return self.__values

    def add(self, instance, name):
        self.__values[instance] = name


class ClassC:
    class_d = ClassD()

    def add(self, name):
        self.class_d.add(self, name)
        
def run2():
    class_c = ClassC()  
    class_c.add('class C')
    print('values:', dict(class_c.class_d.values))

def loop():
    print('_____修正前_____')
    for _ in range(3):
        run1()
    print('_____修正後_____')
    for _ in range(3):
        run2()
        
loop()

# 出力
#_____修正前_____
# values: {<__main__.ClassA object at 0x7fb030375030>: 'class A'}
# values: {<__main__.ClassA object at 0x7fb030375030>: 'class A', 
#          <__main__.ClassA object at 0x7fb030374fd0>: 'class A'}
# values: {<__main__.ClassA object at 0x7fb030375030>: 'class A', 
#          <__main__.ClassA object at 0x7fb030374fd0>: 'class A',
#          <__main__.ClassA object at 0x7fb030374fa0>: 'class A'}
# _____修正後_____
# values: {<__main__.ClassC object at 0x7fb030375000>: 'class C'}
# values: {<__main__.ClassC object at 0x7fb030375000>: 'class C'}
# values: {<__main__.ClassC object at 0x7fb030375000>: 'class C'}