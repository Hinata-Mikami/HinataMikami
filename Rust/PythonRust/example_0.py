# PythonのGCの仕様を考えるためのプログラム
import gc

print(gc.collect())
print(gc.get_stats())

class C:
    pass
        
x1 = C()
x2 = C()

x1.next = x2
x2.next = x2


del x2

print(x1.next)
print(x1.next.next)

print(gc.collect())
print(gc.get_stats())


x1.next = 0

print(gc.collect())
print(gc.get_stats())

