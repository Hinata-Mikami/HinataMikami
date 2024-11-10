# https://qiita.com/Tadataka_Takahashi/items/a5d9654bba38d4eb3686
import gc
import weakref
import sys

class Node:
    def __init__(self, name):
        self.name = name
        self.next = None



# 循環参照を作成
node1 = Node("Node 1")
node2 = Node("Node 2")
node1.next = node2
node2.next = node1


# 参照を削除
del node1
del node2

# ガベージコレクションを実行
# https://docs.python.org/ja/3/library/gc.html
# なぜこれによりgcされていないものがあるのかがわからず...
gc.collect()
print(gc.get_stats())

# [{'collections': 11, 'collected': 7, 'uncollectable': 0}, 
#  {'collections': 0, 'collected': 0, 'uncollectable': 0}, 
#  {'collections': 1, 'collected': 4, 'uncollectable': 0}]



# 循環参照を作成
node1 = Node("Node 1")
node2 = Node("Node 2")
node1.next = weakref.ref(node2)
node2.next = weakref.ref(node1)

# 参照を削除
del node1
del node2

# ガベージコレクションを実行
gc.collect()
print(gc.get_stats())


# [{'collections': 11, 'collected': 7, 'uncollectable': 0}, 
#  {'collections': 0, 'collected': 0, 'uncollectable': 0}, 
#  {'collections': 1, 'collected': 0, 'uncollectable': 0}]


