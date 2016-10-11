use Sangoku 'test';
use Test::Sangoku::PostgreSQL;
use Test::Record;

use Sangoku::Model::Player;
use Sangoku::Model::Unit;

my $TEST_CLASS = 'Sangoku::Model::Unit';
my $PSQL = Test::Sangoku::PostgreSQL->new();
my $TR = Test::Record->new();

# テストの下準備
{
  load "Sangoku::Model::$_" for qw/Country Town Player/;
  "Sangoku::Model::$_"->init() for qw/Country Town Player/;
}

my $PLAYER_ID = Sangoku::Model::Player->ADMINISTARTOR_DATA->{player}{id};

subtest 'create' => sub {
  my $leader = Sangoku::Model::Player->get($PLAYER_ID);

  ok $TEST_CLASS->create({
    leader  => $leader,
    name    => 'テスト部隊',
    message => '部隊紹介文',
  });
};

subtest 'get' => sub {
  ok(my $unit = $TEST_CLASS->get($PLAYER_ID));
  is $unit->name, 'テスト部隊';
};

done_testing();
