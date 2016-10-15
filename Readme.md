# NEO三国志NET
CGIゲーム三国志NETを新しく作りなおしたゲームです。  

# next
```      
* コマンド Js側でのチェック
* API::Command select role 作成, base role 場所変更
* select js部分調整、コード整理

* t/ テストするモジュールのload部分をload関数に
* Rowオブジェクトの処理共通化
* template設定ファイルをどうするか
* API, Rowローダは別に必要なさそう？
* js, scss 外部ファイル化, head読み込みシステム

* plugin -> web 名前空間へ？
* web.pm の処理 外部ファイルに切り出し
* country_position, town country_name
SQL見なおすべきか？

* SQLのチューニング
* 書いてないテストも書きましょうね〜〜
* testのコード共通化進める?
* outer/regist/complete-regist リロードされた時どうするか
```

# 環境設定方法
```
1. 外部環境設定
2. 依存Perlモジュールインストール
3. 設定ファイル記述(etc/config/db.conf, NYTProf.conf, (Site.conf))
4. perl script/setup.pl
```
