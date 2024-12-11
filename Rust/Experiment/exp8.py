class ImmutableObject:
    def __init__(self, **kwargs):
        for key, value in kwargs.items():
            # 親クラスの__setattr__を使用することでErrorを起こさない
            # デフォルトの__setattr__メソッドを使用
            # self.name = value のようなことをしている
            # 属性attrがself.__dict__に追加され、値valueが設定される
            super().__setattr__(key, value)
            
    # obj.attr = value のたびに自動的に呼ばれる関数
    def __setattr__(self, name, value):
        raise AttributeError("Cannot modify immutable object")
    # def __setattr__(self, name, value):
    #     self.name = value  # 無限再帰が発生

    def __delattr__(self, name):
        raise AttributeError("Cannot delete attribute from immutable object")


if __name__ == "__main__": 
    obj = ImmutableObject(x=10, y=20)
    print(obj.x)  # 10
    # obj.x = 30  # AttributeError: Cannot modify immutable object
    
    # obj1 = ImmutableObject(x=[1, 2, 3])
    # print(obj1.x[1])
    
    # obj1.x[1] = 0
    # print(obj1.x[1]) # エラーにならない