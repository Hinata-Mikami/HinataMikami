import gc

gc.set_debug(gc.DEBUG_STATS)

class C:
    def __init__(self, name):
        self.name = name

    def __del__(self):
        print(f"[INFO] {self.name} is being deleted", flush = True)

x1 = C("x1")
x2 = C("x2")
x1.next = x2
x2.next = x2

del x2

x1.next = 0

print("[INFO] The object x1 is:", x1)
print("[INFO] The object x1.next is:", x1.next)
