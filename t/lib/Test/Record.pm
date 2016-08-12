package Test::Record {

  use Record;

  use Path::Tiny;

  sub new {
    my ($class, %args) = @_;

    state $default = {
      record_dir => 'etc/record/',
      tmp_dir    => 'tmp/',
    };
    my $self = {%$default, %args};

    $ENV{TEST_RECORD} = 1;
    $ENV{TEST_RECORD_DIR}     = $self->{record_dir};
    $ENV{TEST_RECORD_TMP_DIR} = $self->{tmp_dir};

    return bless $self, $class;
  }

  sub test_dir {
    my ($self) = @_;
    return $self->{record_dir} . $self->{tmp_dir};
  }

  sub DESTROY {
    my ($self) = @_;

    # テスト用ディレクトリ内の *.dat ファイルを全て削除
    my $iter = path($self->test_dir)->iterator({recurse => 1});
    while (my $path = $iter->() ) {
      $path->remove() if $path =~ /\.dat$/;
    }
  }

}

1;
