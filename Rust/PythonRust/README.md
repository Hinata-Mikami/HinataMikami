Cargo を用いたrustの実効手順

1. 親フォルダで以下を入力しパッケージを作成
    cargo new ???(パッケージ名)

2. パッケージにcd

3. main.rsを編集

4. パッケージフォルダ上でビルド
    cargo build

5. 実行
    cargo run

6. コンパイル可否のチェック
    cargo check
    または
    cargo c

VSCode上ではパッケージフォルダに移動し”実行とデバッグ”（虫マーク）により実行可能