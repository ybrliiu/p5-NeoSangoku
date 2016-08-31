use Sangoku 'test';
use Test::More;
use Test::Sangoku;
use Test::Sangoku::PostgreSQL;

use Sangoku::Model::Player::Guard;

use Sangoku::Util qw/load_config/;

my $site     = load_config('etc/config/site.conf')->{'site'};
my $admin_id = $site->{admin_id};
my $class    = 'Sangoku::Model::Player::Guard';
my $psql     = Test::Sangoku::PostgreSQL->new();

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
  ok $class->create(player_id => $admin_id, power => 0);
};

subtest 'get' => sub {
  ok(my $book = $class->get($admin_id));
  is $book->name, '麻の服';
};

done_testing();
