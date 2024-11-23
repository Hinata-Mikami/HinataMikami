import gc

print("_____GC 0_____")
print(gc.collect())
print(gc.get_stats())

class C:
    pass
        
x1 = C()
x2 = C()
x1.next = x2
x2.next = x2

del x2

print("_____x2 deleted_____")
print(x1.next)
print(x1.next.next)

print("_____GC 1_____")

print(gc.collect())
print(gc.get_stats())


x1.next = 0

print("_____GC 2_____")
print(gc.collect())
print(gc.get_stats())
