# NEO三国志NET
CGIゲーム三国志NETを新しく作りなおしたゲームです。  

# next
```      

* 会議室
 = 再編集用のタグ再置換ヘルパー定義
* 司令部 削除機能

* conference -> conference-room
* conference, row もう1つ root 深く掘る, forum rooting名修正
* 表示スレッド数定数 設定値に

* SQL IN句で書けそうなところは修正する

* Model IconList Threadと似たAPI, 共通部分くくりだし

* mypage map 都市クリックしたらその都市の情報を表示

* フォーラム
* 都市滞在一覧
* 国法
* 司令部

* 継承したほうが適切な場合は継承させる
* Model $class が $self の場合でもちゃんと動くように
* Model $args の中身が多すぎるとちゃんと動かなくなるのを修正
  ( validate_values で 引数の個数検証? )

* スキルクラス考える
* コマンド実行部分考える
* コマンド作成

* アイコンアップローダ
* 雑談BBS

* t/ テストするモジュールのload部分をload関数に

* primary_key を参照するメソッド、modelにあるべきかrowにあるべきか...
  (record系と統一させるならrowにあるべき？, 両方あってもいいような気が)

* plugin -> web 名前空間へ？
* web.pm の処理 外部ファイルに切り出し ( helper -> util )
* SQLのチューニング
* 書いてないテストも書きましょうね〜〜
* testのコード共通化進める?

* Rowオブジェクトの処理共通化(かなり難しいのでよく考えて)
* outer/regist/complete-regist リロードされた時どうするか
* ログイン時のcookie を暗号化
* チャット部分(model-addmethod, 共通化)とコマンド部分(input, choose-select混合部)、なんか汚い

```

# バグ
```
* icon-list 新規ウィンドウで開けばいつでも「アイコンを選択してください」とでてくる
```

# 環境設定方法
```
1. 外部環境設定
2. 依存Perlモジュールインストール
3. 設定ファイル記述(etc/config/db.conf, NYTProf.conf, (Site.conf))
4. perl script/setup.pl
```
