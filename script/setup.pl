# 4: setup.pl
# 実行方法:project root から perl script/set_up.pl

use FindBin;
use lib "$FindBin::Bin/../lib";
use Sangoku;

use DBI;
use Sangoku::Util qw/load_config load/;
use SQL::SplitStatement;
use Path::Tiny;
use Sangoku::Service::Admin::ResetGame;

binmode STDOUT, 'utf8';
binmode STDIN, 'utf8';

say 'スキーマからテーブルを作成しています...';
prepare_tables();
say 'テーブル作成完了';

say '使用するディレクトリを作成しています...';
prepare_dir();
say 'ディレクトリ作成完了';

print "リセット後の更新開始日時を指定してください:";
chomp(my $reset_time = <STDIN>);
say '初期化中...';
Sangoku::Service::Admin::ResetGame->init_data_all($reset_time);
say '初期化が終わりました';

sub prepare_tables {
  my $config = load_config('db.conf');
  my $dbh = DBI->connect(@{ $config->{connect_info} }) || die 'dbi fail.';
  my $file = path('etc/documents', 'sangoku_schema.sql');
  my $sql = $file->slurp();
  my $splitter = SQL::SplitStatement->new(
    keep_terminator      => 1,
    keep_comments        => 0,
    keep_empty_statement => 0,
  );
  for ($splitter->split($sql)) {
    $dbh->do($_) || die $dbh->errstr;
  }
}

sub prepare_dir {

  my $player_model = 'Sangoku::Model::Player';
  load $player_model;
  my @modules = map { "Sangoku::API::Player::$_" } @{ $player_model->CHILD_RECORD_MODULES };
  load $_ for @modules;
  _touchpath(\@modules);

  # dir for test (create tmp/). see also Test::Record
  {
    push @INC, "$FindBin::Bin/../t/lib";
    load "Test::Record";
    my $tr = Test::Record->new();
    _touchpath(\@modules);
  }

}

sub _touchpath {
  my ($modules) = @_;
  for my $module (@$modules) {
    (my $file_path = $module->file_path('')) =~ s/\.dat/\.gitkeep/g;
    path($file_path)->touchpath();
  }
}

