# Model層規約
・必要に応じてSangoku::Model::Roleを使用  
・オブジェクト指向：Mouse(継承、Mixin、委譲など必要なときのみ使用)  
・引数チェック:自作関数(Sangoku::Util::validate_keys, validate_args),  
・引数が多い時の受取方法:HashRef  
・例外処理:eval-if  
・必要に応じてException::Tinyを継承した例外搬送クラスを作成  
・クラスメソッドのみで作成できるならそれで良い  

## ディレクトリ構成
```
Model/Player/
            /Config
            /Weapon
            /Guard
            /Book
            /CommandRecord
            /BattleRecord
            /Soldier
            /Skill
            /Letter
            /Invite
            /Command        # Record.pm
            /CommandList    # Record.pm
            /CommandLog     # Record.pm
     /Country/
             /Position
             /Law
             /Conference
             /Letter
     /Unit/
          /Letter
     /Town/
          /Letter
     /Site

     /LoginList       # Cache::ShareMemory
     /Announce
     /ForumThread
     /ForumReply
     /IdleTalk
     
     /Diplomacy
     /IconUploader
     /MapLog       # Record.pm
     /HistoryLog   # Record.pm
     /AdminLog     # Record.pm を継承

     /Book         # Config HashRef -> ArrayRefにして順序を保証、HashRefでデータ欲しい時はModelでmethod作って対応
     /Weapon
     /Guard
     /Soldier
     /Skill
     /InitTownData

     /Role/DB
             /Parent
             /Letter

          /Config
          /Log
          /Letter
          /BBS
```

# API層規約
・Model層で管理対象になるオブジェクトクラスの定義をする。(例:Record.pmのクラス、設定ファイルの情報のオブジェクトクラス(武器、兵士など))  
・Mouseで記述する。  

# Service層規約
・URLのエンドポイントに応じてクラス作成 + ループ(バッチ)処理の処理  
・バリデーションもここに書く(Sangoku::Validatorで)  
・トランザクション&eval-ifはここで  
・トランザクションの管理はこちらで基本する。  
・エラー検証＆エラーデータ格納はSangoku::Validatorに  

```
     /Command/
             /各コマンドのモジュール
```

# Controller規約
基本的に以下のように書く。  
バリデーションは基本的にここでしない。  

``` perl
sub root {
  my self = shift;

  my $player_id = '';
  my ($result, $error) = Sangoku::Service::Player->mypage($player_id);

  $error->has_error() ? $self->stash(errors => $error->info) : $self->stash(errors => {});
  $self->stash(%$result);

  $self->render();
  # or
  $self->render(template => 'player/unit/root', variant => 'phone');
}
```

