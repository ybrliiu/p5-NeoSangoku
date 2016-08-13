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

    $ENV{TEST_RECORD} = 0;

    # テスト用ディレクトリ内の *.dat ファイルを全て削除
    my $iter = path($self->test_dir)->iterator({recurse => 1});
    while (my $path = $iter->() ) {
      $path->remove() if $path =~ /\.dat$/;
    }
  }

}

1;

__END__

=encoding utf-8

=head1 名前
  
  Test::Record - Record.pmのためのテストモジュール
  
=head1 使用法

  # ディレクトリ作成例(デフォルト）
  etc/record/          # 本番環境使用用
  etc/record/tmp/      # テスト環境使用用

  # 定義クラス側
  package Example::API::Example {

    ...

    sub file_path {
      my ($class) = @_;

      my $default = 'etc/record/example.dat';

      # テストの時にデータを保存する相対パスを指定
      if ($ENV{TEST_RECORD}) {
        my $regex = '\D' x length($ENV{TEST_RECORD_DIR});
        (my $test_path = $default) =~ s!($regex)!$1$ENV{TEST_RECORD_TMP_DIR}/!;
        $test_path;
      }
      
      # 通常時のパス
      else {
        $default;
      }
    }

  }

  # テスト側
  # 指定されたテスト環境用ディレクトリ内にデータを作成、テスト終了時に作成データは全消去)
  my $rec = Test::Record->new();
  
=head1 環境変数

=head2 $ENV{TEST_RECORD}
  
  Test::Recordでテストしている時に'1'がセットされます。

=head2 $ENV{TEST_RECORD_DIR}
  
  Record.pmで保存したデータ群のディレクトリ,new メソッドで指定します。
  カレントディレクトリの相対的なパスになります

=head2 $ENV{TEST_RECORD_TMP_DIR}
  
  testで使用するデータを保存するディレクトリ。$ENV{TEST_RECORD_DIR}の中にあるものとして扱われます

=head1 メソッド
  
=head2 new

  インスタンスを生成、テスト環境の構築をします。

  必須引数：なし
  任意の引数：tmp_dir(default:'tmp/'), record_dir(default:'etc/record/')

  $ENV{TEST_RECORD_DIR} に record_dir の値を、 $ENV{TEST_RECORD_TMP_DIR} に tmp_dirの値をセットします。

=head2 DESTROY

  テスト終了時にDESTROYメソッドが呼ばれテスト用ディレクトリに作成したデータは全て削除されます。
  ※拡張子が.datである必要があります

=head2 test_dir

  テスト環境用のディレクトリの相対パスを返します。

=cut

