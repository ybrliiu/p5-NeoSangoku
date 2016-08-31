use Sangoku 'test';
use Test::More;
use Test::Sangoku;
use Test::Sangoku::PostgreSQL;
use Test::Record;

use Sangoku::Model::Player;

use Sangoku::Util qw/load_config/;

my $TEST_CLASS = 'Sangoku::Model::Player';
my $PSQL  = Test::Sangoku::PostgreSQL->new();

# テストの下準備
{
  eval "require Sangoku::Model::$_" for qw/Country Town/;
  "Sangoku::Model::$_"->init() for qw/Country Town/;
}

subtest 'init' => sub {
  $TEST_CLASS->init();
  ok 1;
};

subtest 'get' => sub {
  my $site = load_config('etc/config/site.conf')->{'site'};
  my $admin_id = $site->{admin_id};
  ok(my $town = $TEST_CLASS->get($admin_id));
  is $town->name, '管理人';
};

subtest 'create' => sub {
  ok 1;
};

done_testing();
