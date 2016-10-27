package Sangoku::Util {

  use Sangoku;

  use Exporter 'import';
  # methods は role に切り出すべき
  my @LOADER_METHODS = qw/model row api/;
  my @METHODS = (@LOADER_METHODS, qw/get_all_constants/);
  our @EXPORT_OK = (
    qw/
      project_root_dir load_config validate_values minute_second
      daytime date datetime child_module_list load_child_module
      config
      load
    /,
    @METHODS,
  );

  use Carp qw/croak/;
  use Cwd 'getcwd';
  use Config::PL;
  use Time::Piece;
  use Encode 'decode';
  use Path::Tiny;
  use Module::Load;

  use constant CONFIG_DIR_PATH => 'etc/config/';

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
    config_do(CONFIG_DIR_PATH . $path);
  }

  # 引数ハッシュのチェック
  sub validate_values {
    my ($args, $keys, $name) = @_;
    $name = defined $name ? "$name\の" : '';

    croak 'HashRefが渡されていません' if ref $args ne 'HASH';

    my @not_exists = grep { not exists $args->{$_} } @$keys;
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
      if ($path !~ /(Base|Role)/ && $path =~ /\.pm$/) {
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
      load $module;
    }
    return $list;
  }

  sub random_color {
    state $color_strs = [0 .. 9, 'a' .. 'f'];
    state $color_strs_len = @$color_strs;
    my $color_code = '#' . join('', map { $color_strs->[int(rand $color_strs_len)] } 0 .. 5);
    return $color_code;
  }

  sub config {
    my ($file) = @_;
    state $config = {};
    $config = { %$config, %{ load_config $file } } if defined $file;
    return $config;
  }

  # package名からそのpkg内の定数一覧を取得
  sub get_all_constants {
    my ($pkg) = @_;

    state $cache = {};
    return $cache->{$pkg} if exists $cache->{$pkg};

    no strict 'refs';
    my %table = %{"${pkg}::"};
    use strict 'refs';

    my %constants = map {
      (my $key = $_) =~ s/${pkg}:://g;
      my $value = $table{$key};
      if ($key !~ /[^A-Z0-9_]/) {
        if (ref $value) {
          $key => $$value;
        } elsif (defined *{$value}{CODE}) {
          $key => *{$value}{CODE};
        } else {
          ();
        }
      } else {
        ();
      }
    } keys %table;
    $cache->{$pkg} = \%constants;
  }

  __PACKAGE__->_generate_loader_method();

  sub _generate_loader_method {

    my %pkg_name;
    @pkg_name{@LOADER_METHODS} = qw/Model DB::Row API/;
    
    for my $method (@LOADER_METHODS) {

      no strict 'refs';
      *$method = sub {
        use strict 'refs';
        my ($class, $name) = @_;

        state $module_names = {};
        return $module_names->{$name} if exists $module_names->{$name};

        my $pkg = "Sangoku::$pkg_name{$method}::$name";
        load $pkg;
        $module_names->{$name} = $pkg;
      };

    }

  }

}

1;
