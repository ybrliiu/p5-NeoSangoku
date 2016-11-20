package Sangoku::Model::Site {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::RecordSingleFile';

  use Carp qw/croak/;
  use Try::Tiny;
  use Sangoku::API::Site;
  use Time::Piece;

  use constant CLASS => 'Sangoku::API::Site';

  sub init {
    my ($class, $start_time) = @_;
    croak '更新開始時間が指定されていません' unless $start_time;

    my $epoch_time = eval {
      # Time::Pieceからインスタンス生成すると、タイムゾーンがずれるので,localtimeの中でする必要がある
      # see also http://d.hatena.ne.jp/hirose31/20110210/1297341952
      my $time = localtime( Time::Piece->strptime(
        "${start_time}00分00秒",
        "%Y年%m月%d日%H時%M分%S秒"
      ));
      $time->epoch();
    };
    croak "時刻指定の書式が間違っています(書式:xx年xx月xx日xx時)" if $@;

    eval {
      my $record = $class->record->open('LOCK_EX');
      my $site = $record->at(0);
      $site->term($site->term + 1);
      $site->start_time($epoch_time);
      $record->close();
    };

    if (my $e = $@) {
      if (Record::Exception->caught($e)) {
        my $record = $class->record;
        $record->make();
        my $site = CLASS->new(start_time => $epoch_time);
        $record->open('LOCK_EX');
        $record->add($site);
        $record->close();
      }
    }

  }

  sub get {
    my ($class) = @_;
    return $class->record->open->at(0);
  }

}

1;
