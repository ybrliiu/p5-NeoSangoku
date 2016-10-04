# NEO三国志NET
CGIゲーム三国志NETを新しく作りなおしたゲームです。  

# next
```
* reset_game delete_all model::player::を model::player::erase_allに
* API ディレクトリの場所を定数で指定
* create Player profile

* map log
- design
- 前回のをベースに、上部はmax-width指定
- 全体的にマージンをとってrootのパーツを流用する

" player-list
- 前回のをほぼそのまま踏襲

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
