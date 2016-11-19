use Sangoku 'test';
use Test::Sangoku::PostgreSQL;
use Test::Record;

use Sangoku::Model::Player;

my $TEST_CLASS = 'Sangoku::Model::Player';
my $PSQL = Test::Sangoku::PostgreSQL->new();
my $TR = Test::Record->new();
my $PLAYER_DATA = $TEST_CLASS->ADMINISTARTOR_DATA->{player};

# テストの下準備
{
  load "Sangoku::Model::$_" for qw/Country Town/;
  "Sangoku::Model::$_"->init() for qw/Country Town/;
}

subtest 'create&delete&get' => sub {
  $TEST_CLASS->create($PLAYER_DATA);
  get_id_and_check_name();
  $TEST_CLASS->delete($PLAYER_DATA->{id});
};

subtest 'regist&erase' => sub {
  $TEST_CLASS->regist($TEST_CLASS->ADMINISTARTOR_DATA);
  get_id_and_check_name();
  $TEST_CLASS->erase($PLAYER_DATA->{id});
};

subtest 'init&get' => sub {
  $TEST_CLASS->init();
  get_id_and_check_name();
};

subtest 'delete_all' => sub {
  ok $TEST_CLASS->delete_all();
};

sub get_id_and_check_name {
  ok(my $player = $TEST_CLASS->get($PLAYER_DATA->{id}));
  is $player->name, $PLAYER_DATA->{name};
  ok($player = $TEST_CLASS->get_joined($PLAYER_DATA->{id}));
  is $player->name, $PLAYER_DATA->{name};
  ok($player = $TEST_CLASS->get_by_name($PLAYER_DATA->{name}));
  is $player->id, $PLAYER_DATA->{id};
}

done_testing();
