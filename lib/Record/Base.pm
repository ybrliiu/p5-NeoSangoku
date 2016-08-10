package Record::Base {

  use Mouse::Role;
  use Record;
  use Storable qw/fd_retrieve nstore_fd nstore/; # データ保存用
  
  # アテリビュート(フィールド+アクセッサ)
  has 'file' => (is => 'rw', isa => 'Str', required => 1);
  has 'fh' => (is => 'rw', isa => 'FileHandle');
  
  sub data {
    my $self = shift;
    state $memory = {};
    if (@_) {
      $memory->{$self->file} = shift;
    }
    return exists $memory->{$self->file} ? $memory->{$self->file} : ();
  }

  # インスタンス生成後処理
  sub BUILD {
    my $self = shift;
    $self->file( Record->project_dir() . $self->file );
  }
  
  # ファイルオープン
  sub open {
    my ($self, $lock) = @_;
    $lock //= '';

    # モード
    state $mode = {
      LOCK_SH => 1,    # 共有ロック
      LOCK_EX => 2,    # 排他ロック
      NB_LOCK_SH => 5, # ノンブロックな共有ロック(ノンブロックの場合、ロックできなければdie）
      NB_LOCK_EX => 6, # ノンブロックな排他ロック
    };

    if (exists $mode->{$lock}) {
      open(my $fh, '+<', $self->file) or Record::Exception->throw("fileopen失敗:$!", $self);
      $self->fh($fh);
      flock($self->fh, $mode->{$lock}) or Record::Exception->throw("flock失敗:$!", $self);
      $self->data(fd_retrieve $self->fh);
    } else {
      open(my $fh, '<', $self->file) or Record::Exception->throw("fileopen失敗:$!", $self);
      $self->data(fd_retrieve $fh);
      $fh->close;
    }

    return $self;
  }
  
  # ファイル作成
  sub make {
    my $self = shift;
    unless (-e $self->file) {
      nstore($self->data, $self->file);
    } else {
      Record::Exception->throw("既にファイルが存在しています", $self);
    }
    return $self;
  }
  
  # ファイル閉じる
  sub close {
    my $self = shift;
    truncate($self->fh, 0) or Record::Exception->throw("ファイルを開いていないか2度ファイルを開いています:$!", $self);
    seek($self->fh, 0, 0) or Record::Exception->throw("seek失敗:$!", $self);
    nstore_fd($self->data, $self->fh) or Record::Exception->throw("nstore_fd失敗:$!", $self);
    close($self->fh) or Record::Exception->throw("close失敗:$!", $self);
    return 1;
  }

  sub rollback {
    my $self = shift;
    $self->data(undef);
    $self->open;
    $self->close;
  }
  
  # ファイル削除
  sub remove {
    my $self = shift;
    unlink($self->file) or Record::Exception->throw("ファイルが存在していないようです($!)", $self);
  }
  
}

1;
