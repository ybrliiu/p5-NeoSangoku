use Sangoku 'test';
use Test::More;
use Test::Sangoku;
use Test::Sangoku::PostgreSQL;

use Sangoku::Model::Player::Guard;

use Sangoku::Util qw/load_config/;

my $ADMIN_ID = load_config('etc/config/site.conf')->{site}{admin_id};
my $TEST_CLASS    = 'Sangoku::Model::Player::Guard';
my $PSQL     = Test::Sangoku::PostgreSQL->new();

# テストの下準備
{
  eval "require Sangoku::Model::$_" for qw/Country Town Player/;
  "Sangoku::Model::$_"->init() for qw/Country Town Player/;
}

subtest 'init' => sub {
  $TEST_CLASS->init();
  ok 1;
};

subtest 'create' => sub {
  ok $TEST_CLASS->create({player_id => $ADMIN_ID, power => 0});
};

subtest 'get' => sub {
  ok(my $book = $TEST_CLASS->get($ADMIN_ID));
  is $book->name, '麻の服';
};

done_testing();
