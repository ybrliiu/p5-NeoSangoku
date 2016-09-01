package Sangoku::Util {

  use Sangoku;

  use Carp qw/croak/;
  use Exporter 'import';
  our @EXPORT_OK = qw/project_root_dir load_config validate_keys minute_second daytime date datetime child_module_list load_child_module/;

  use Cwd 'getcwd';
  use Config::PL;
  use Time::Piece;
  use Encode 'decode';
  use Path::Tiny;

  # プロジェクトルートディレクトリ取得
  sub project_root_dir {
    state $dir;
    return $dir if $dir;
    $dir = getcwd() . '/';
    return $dir;
  }

  # 設定ファイル読み込み
  sub load_config {
    my ($path) = @_;
    config_do(project_root_dir() . $path);
  }

  # 引数ハッシュのチェック
  sub validate_keys {
    my ($args, $keys, $name) = @_;
    $name = defined $name ? "$name\の" : '';

    croak 'HashRefが渡されていません' if ref $args ne 'HASH';

    my @not_exists = map { !exists($args->{$_}) ? $_ : () } @$keys;
    if (@not_exists) {
      my ($file, $line) = (caller 1)[1 .. 2];
      # die関数の最後に\nを入れるとdieした時にファイル名と行が出力されなくなる
      die "$name キーが足りません(@{[ join(', ', @not_exists) ]}) at $file line $line\n";
    }
  }
  
  # 分秒出力
  sub minute_second {
    my ($time) = @_;
    my $t = localtime($time);
    decode('utf-8', $t->strftime('%M分%S秒'));
  }

  # 日時時刻出力
  sub daytime {
    my ($time) = @_;
    my $t = localtime($time);
    decode('utf-8', $t->strftime('%d日%H時%M分%S秒'));
  } 
  
  # 年月日時曜日出力
  sub date {
    my ($time) = @_;
    my $t = localtime($time);
    decode('utf-8', $t->strftime('%Y/%m/%d(%a)'));
  }
  
  # 年月日時曜日時刻出力
  sub datetime {
    my ($time) = @_;
    my $t = localtime($time);
    decode('utf-8', $t->strftime('%Y/%m/%d(%a) %H:%M:%S'))
  }

  # package名から子ディレクトリのリスト作成(再帰的に)
  sub child_module_list {
    my ($pkg) = @_;
    $pkg //= '';

    my $root = project_root_dir() . 'lib/';
    (my $dir = $root . $pkg) =~ s!::!/!g;

    my $iter = path($dir)->iterator({recurse => 1});
    my @list;
    while (my $path = $iter->()) {
      if ($path !~ /^Base/ && $path =~ /\.pm$/) {
        $path =~ s!$root!!g;
        $path =~ s!.pm$!!;
        $path =~ s!/!::!g;
        push @list, $path;
      }
    }

    return \@list;
  }

  # package名から子ディレクトリ内にあるモジュールをロード
  sub load_child_module {
    my ($pkg) = @_;
    my $list = child_module_list($pkg);
    for (0 .. @$list-1) {
      my $module = $list->[$_];
      eval "require $module";
    }
    return $list;
  }
  
}

1;
