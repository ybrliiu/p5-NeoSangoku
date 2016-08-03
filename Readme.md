# next
[issue]
Model db, connect_infoはインスタンス変数にしないと他のdb, userから接続できない->修正
testのとき tableに依存関係がいろいろあると初期化時の単体テストがとてもやりにくい->どうするか？
さらに、testのことを考えつつService層をどうするかも考える必要がある(これもインスタンス変数化？

DBクラス定義
Configクラス定義
Recordクラス定義
Townモデル定義、都市の初期化
