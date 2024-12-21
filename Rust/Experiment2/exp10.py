class List:
    def __init__(self, value=None, next_item=None):
        self.value = value
        self.next_item = next_item  # `RefCell<Rc<List>>` を模倣

    def tail(self):
        if self.next_item is not None:
            return self.next_item
        return None


def main():
    # `Rc::new(Cons(...))` を模倣
    a = List(5, None)  # Nil を `None` で表現

    b = List(10, a)  


if __name__ == "__main__":
    main()
