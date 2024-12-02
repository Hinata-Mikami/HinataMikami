print("Hello world!")

# または main関数を定義し， if ．．．で呼び出し
# pythonはmain関数を書いただけでは実行されないのであまり意味はない
# この書き方のメリットは，main()の定義以降で定義された関数も使用可能
# Rust は関数定義の順番に制限はない→この書き方なら整合性が取れる？
def main():
    print("main was called!")
    sub()
    
def sub():
    print("sub was called!")

# モジュールとしてインポートされるときは __name__ == "__exp1__"に．
# プログラム実行時は __name__ == "__main__"になるので実行される.
# https://docs.python.org/ja/3/library/__main__.html
if __name__ == "__main__":
    main()
