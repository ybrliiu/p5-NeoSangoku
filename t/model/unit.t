use Sangoku 'test';
use Test::More;
use Test::Sangoku;
use Test::Sangoku::PostgreSQL;

use Sangoku::Model::Unit;

use Sangoku::Util qw/load_config/;

my $class    = 'Sangoku::Model::Unit';
my $psql     = Test::Sangoku::PostgreSQL->new();
my $admin_id = load_config('etc/config/site.conf')->{'site'}{'admin_id'};

# テストの下準備
{
  eval "require Sangoku::Model::$_" for qw/Country Town Player/;
  "Sangoku::Model::$_"->init() for qw/Country Town Player/;
}

subtest 'init' => sub {
  $class->init();
  ok 1;
};

subtest 'create' => sub {
  ok $class->create(
    id   => $admin_id,
    name => 'テスト部隊',
    message      => '',
    country_name => '無所属',
  );
};

subtest 'get' => sub {
  ok(my $unit = $class->get($admin_id));
  is $unit->name, 'テスト部隊';
};

done_testing();
