use Sangoku 'test';
use Test::More;
use Test::Sangoku;
use Test::Sangoku::PostgreSQL;
use Test::Record;

use Sangoku::Model::Unit;

my $TEST_CLASS = 'Sangoku::Model::Unit';
my $PSQL = Test::Sangoku::PostgreSQL->new();
my $TR = Test::Record->new();

# テストの下準備
{
  eval "require Sangoku::Model::$_" for qw/Country Town Player/;
  "Sangoku::Model::$_"->init() for qw/Country Town Player/;
}

my $PLAYER_ID = Sangoku::Model::Player->ADMINISTARTOR_DATA->{player}{id};

subtest 'init' => sub {
  $TEST_CLASS->init();
  ok 1;
};

subtest 'create' => sub {
  ok $TEST_CLASS->create({
    id   => $PLAYER_ID,
    name => 'テスト部隊',
    message      => '',
    country_name => '無所属',
  });
};

subtest 'get' => sub {
  ok(my $unit = $TEST_CLASS->get($PLAYER_ID));
  is $unit->name, 'テスト部隊';
};

done_testing();
