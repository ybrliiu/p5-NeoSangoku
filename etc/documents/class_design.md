# Model層規約
必要に応じてSangoku::Model::Roleを使用
オブジェクト指向：Mouse(継承、Mixin、委譲など必要なときのみ使用) ただし、DB::Row::*は非Mouse(Mouseだと上手く動かないっぽい)
引数チェック:自作関数(Sangoku::Util::validate_args), or Data::Validater
例外処理:eval-if
必要に応じてException::Tinyを継承した例外搬送クラスを作成

できる限りクラスメソッドのみで作成

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
Sangoku::Config以下に設定ファイルのクラスを記述

# Service層規約
・URLのエンドポイントに応じてクラス作成 + ループ処理の処理
・バリデーションもここに書く(Mojo::Validatorで)
・トランザクション&eval-ifはここで(=これもインスタンス化
・エラー検証＆エラーデータ格納はSangoku::Validatorに

     /Command/
             /各コマンドのモジュール


# Controller規約
基本的に以下のように書く
バリデーションは基本的にここでしない

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

