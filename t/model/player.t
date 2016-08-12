use Sangoku 'test';
use Test::More;
use Test::Sangoku;
use Test::Sangoku::PostgreSQL;

use Sangoku::Model::Player;

use Sangoku::Util qw/load_config/;

my $class = 'Sangoku::Model::Player';
my $psql  = Test::Sangoku::PostgreSQL->new();

# テストの下準備
{
  eval "require Sangoku::Model::$_" for qw/Country Town/;
  "Sangoku::Model::$_"->init() for qw/Country Town/;
}

subtest 'init' => sub {
  $class->init();
  ok 1;
};

subtest 'get' => sub {
  my $site = load_config('etc/config/site.conf')->{'site'};
  my $admin_id = $site->{admin_id};
  ok(my $town = $class->get($admin_id));
  is $town->name, '管理人';
};

subtest 'regist' => sub {
  ok 1;
};

done_testing();
