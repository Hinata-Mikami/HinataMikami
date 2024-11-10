# https://stackoverflow.com/questions/2017381/is-it-possible-to-have-an-actual-memory-leak-in-python-because-of-your-code
import time

def foo(a=[]):
    a.append(time.time())
    return a

for i in range(5):
    print(f"{i+1} : {foo()}")