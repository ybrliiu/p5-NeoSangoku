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
Model/Role/DB/
             /Parent
             /Letter
             /Thread
             /Reply
          /Cache
          /Record
          /RecordSingle/
                       /Log
          /RecordMultiple
          /Config

     /Player/
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
             /Diplomacy
     /Unit/
          /Letter
     /Town/
          /Letter
          /Guards

     /Site         # Record.pm

     /LoginList       # Cache::ShareMemory
     /Announce
     /ForumThread
     /ForumReply
     /IdleTalk
     /IconUploader
     
     /MapLog       # Record.pm
     /HistoryLog   # Record.pm
     /AdminLog     # Record.pm を継承

     /Command      # コマンドモジュール(API::Command::*)の管理

     /Book         # Config HashRef -> ArrayRefにして順序を保証、HashRefでデータ欲しい時はModelでmethod作って対応
     /Weapon
     /Guard
     /Soldier
     /Skill
     /InitTownData

```

# API層規約
・Model層で管理対象になるオブジェクトクラスの定義をする。(例:Record.pmのクラス、設定ファイルの情報のオブジェクトクラス(武器、兵士など))  
・Mouseで記述する。  

# API::Command層規約

# Service層規約
・URLのエンドポイントに応じてクラス作成 + ループ(バッチ)処理の処理  
・バリデーションもここに書く(Sangoku::Validatorで)  
・トランザクション&eval-ifはここで  
・トランザクションの管理はこちらで基本する。  
・エラー検証＆エラーデータ格納はSangoku::Validatorに  

# Controller規約
基本的に以下のように書く。  
バリデーションは基本的にここでしない。  

``` perl

sub root {
  my ($self) = @_;
  my $player_id = $self->session('id');
  my $result = Sangoku::Service::Player->mypage($player_id);
  $self->stash(%$result);
  $self->flash_error(); # フォームのエラー
  $self->render();
}

sub regist {
  my ($self) = @_;
  my $param = $self->req->params->to_hash();
  my $error = $self->service->regist($param);

  if ($error->has_error) {
    $self->flash_error($error);
    $self->redirect_to('/outer/regist');
  } else {
    $self->flash(id => $self->param('id'));
    $self->redirect_to('/outer/regist/complete-regist');
  }
}

```

