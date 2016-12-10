package Sangoku::Util {

  use Sangoku;

  use Exporter 'import';
  our @EXPORT_OK = (
    qw/
      project_root_dir load_config validate_values minute_second
      daytime date datetime child_module_list load_child_module
      escape
      load
    /,
  );

  use Carp qw/croak/;
  use Cwd 'getcwd';
  use Config::PL;
  use Time::Piece;
  use Encode 'decode';
  use Path::Tiny;
  use Module::Load;
  use HTML::Escape;

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

  # xmlエスケープ、特別に使用可能なタグのみエスケープしない
  sub escape {
    my ($str) = @_;
    
    # xmlエスケープ
    my $result = escape_html($str);
    
    # \n→<br>
    $result =~ s/\n/<br>/g;

    # 使用可能なタグの変換
    my @colors = qw/red blue darkblue lightblue black green/;
    my @decorations = qw/b u i sub/;
    my @tags = (@colors, @decorations, 'a');

    for (0 .. $#tags){
      my $tag = $tags[$_];
      if($result =~ /&lt;$tag&gt;/){
        if($_ < @colors + @decorations){
          return $result if _validate($result, $tag);
          if($_ < @colors){
            $result = _make_color($result, $tag);
          }elsif($_ < @colors + @decorations){
            $result = _make_decoration($result, $tag);
          }
        }else{
          $result = _make_link($result);
        }
      }
    }
    
    return "$result"; # Mojo::ByteStreamオブジェクトを文字型に
  }
  
  # 不正な形のタグが含まれていないか検査
  sub _validate {
    my ($str, $tag) = @_;
    return 1 if $str =~ qr/&lt;$tag&gt;$/; # 末尾に開始タグがあればアウト
    
    my @validate = split(/&lt;$tag&gt;/,$str); # 開始タグで分割し、全てのタグに閉じタグがあるか検査
    for (1 .. @validate - 1) {
      return 1 if $validate[$_] !~ /&lt;\/$tag&gt;/;
    }
    return 0;
  }
  
  # 色タグの作成
  sub _make_color {
    my ($str, $tag) = @_;
    $str =~ s/&lt;$tag&gt;/<span style="color:$tag">/g;
    $str =~ s/&lt;\/$tag&gt;/<\/span>/g;  
    return $str;
  }
  
  # 装飾タグの作成
  sub _make_decoration {
    my ($str, $tag) = @_;
    $str =~ s/&lt;$tag&gt;/<$tag>/g;
    $str =~ s/&lt;\/$tag&gt;/<\/$tag>/g;
    return $str;
  }   
  
  # リンクタグの検査、作成
  sub _make_link {
    my $str = shift;
    return $str if $str =~ /&lt;a&gt;$/;
    
    my @validate = split(/&lt;a&gt;/, $str);
    my (@url, @name);
    for(1 .. @validate-1){
      ($url[$_])  = $validate[$_] =~ /url:(.*?) name:/;          # URL抽出
      ($name[$_]) = $validate[$_] =~ / name:(.*?)&lt;\/a&gt;/;   # リンク名抽出
      return $str unless $name[$_] && $url[$_];                  # URLかリンク名、閉じタグがなければアウト
      ($validate[$_]) = $validate[$_] =~ /(?<=&lt;\/a&gt;)(.*)/; # 閉じタグより後ろの部分を抽出
    }
    
    my $result = $validate[0];
    $result .= qq{<a href="$url[$_]">$name[$_]</a>$validate[$_]} for(1 .. @validate-1);
    return $result;
  }
  
}

1;
