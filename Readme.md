# NEO三国志NET
CGIゲーム三国志NETを新しく作りなおしたゲームです。  

# next
```      

* css grid row 追加
* JS setTimeout

* player status 表示レイアウト変更

* 個人宛手紙、mypageに履歴から送信追加、手紙ログ

* JS package と class の区別を明確に...
* ログイン時のcookie を暗号化

* Model::Site 月をまたがる場合や年をまたがる場合は？

* t/ テストするモジュールのload部分をload関数に
* js, scss 外部ファイル化, head読み込みシステム

* primary_key を参照するメソッド、modelにあるべきかrowにあるべきか...
  (record系と統一させるならrowにあるべき？, 両方あってもいいような気が)

* plugin -> web 名前空間へ？
* web.pm の処理 外部ファイルに切り出し
* country_position, town country_name SQL見なおすべきか？
* SQLのチューニング
* 書いてないテストも書きましょうね〜〜
* testのコード共通化進める?
* Rowオブジェクトの処理共通化(かなり難しいのでよく考えて)
* outer/regist/complete-regist リロードされた時どうするか
```

# 環境設定方法
```
1. 外部環境設定
2. 依存Perlモジュールインストール
3. 設定ファイル記述(etc/config/db.conf, NYTProf.conf, (Site.conf))
4. perl script/setup.pl
```
