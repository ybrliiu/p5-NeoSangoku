# NEO三国志NET
CGIゲーム三国志NETを新しく作りなおしたゲームです。  

# next
```
* Rowオブジェクと modelローダ化
* Rowオブジェクトの処理共通化
* template設定ファイルは必要なさそう(serviceで定数化)
* js 名前空間全て先頭小文字に
* API, Rowローダは別に必要なさそう？
* test の eval "require ..." を load に

* country_position, town country_name
SQL見なおすべきか？

* SQLのチューニング
* 書いてないテストも書きましょうね〜〜
* testのコード共通化進める?
* complete_regist リロードされた時どうするか
```

# 環境設定方法
```
1. 外部環境設定
2. 依存Perlモジュールインストール
3. 設定ファイル記述(etc/config/db.conf, NYTProf.conf, (Site.conf))
4. perl script/setup.pl
```
