# Model層規約
必要に応じてJikkoku::Model::Roleを使用
オブジェクト指向：Mouse(継承、Mixin、委譲など必要なときのみ使用) ただし、DB::Row::*は非Mouse(Mouseだと上手く動かないっぽい)
引数チェック:自作関数(Jikkoku::Util::validate_args), or Data::Validater
例外処理:eval-if
必要に応じてException::Tinyを継承した例外搬送クラスを作成

基本クラスメソッドのみで作成
必要なときのみインスタンスメソッド
コマンドモジュールはインスタンス化できるように

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
          /LoginList       # Redis
     /Notice
     /Forum
     /IdleTalk
     /Diplomacy
     /IconUploader
     /MapLog       # Record.pm
     /HistoryLog   # Record.pm
     /AdminLog     # Record.pm を継承

     /Book
     /Weapon
     /Guard
     /Soldier
     /Skill

     /Role/DB.pm
          /Config.pm
          /Log.pm
          /Letter.pm
          /BBS.pm
          /Redis.pm

# Config層規約
Jikkoku::Config以下に設定ファイルのクラスを記述

# Service層規約
URLのエンドポイントに応じてクラス作成 + ループ処理の処理
基本的にクラスメソッドの集合
エラーはJikkoku::Errorクラスに格納
トランザクション&eval-ifはここで

     /Command/
             /各コマンドのモジュール


# Controller規約
基本的に以下のように書く

sub root {
  my self = shift;

  my $player_id = '';
  my ($result, $error) = Jikkoku::Service::Player->mypage($player_id);

  $self->stash(error => $error) if $error->has_error;
  $self->stash(%$result);

  $self->render();
  # or
  $self->render(template => 'player/unit/root', variant => 'phone');
}

