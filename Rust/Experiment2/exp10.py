class Node:
    def __init__(self, next = None):
        self.next = next

def main():
    # ノードを作成
    node1 = Node()
    node2 = Node(next = node1)

    # 循環参照を設定
    node1.next = node2

if __name__ == "__main__":
    main()

# gcを呼べば即時解放可能