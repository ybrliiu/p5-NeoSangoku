use Sangoku 'test';
use Test::Sangoku::PostgreSQL;
use Test::Sangoku::Util qw/prepare_player_model_tests/;

use Sangoku::Model::Player;
use Sangoku::Model::Player::BattleRecord;

my $PLAYER_ID = Sangoku::Model::Player->ADMINISTARTOR_DATA->{player}{id};
my $TEST_CLASS = 'Sangoku::Model::Player::BattleRecord';
my $PSQL = Test::Sangoku::PostgreSQL->new();

prepare_player_model_tests();

subtest 'create' => sub {
  ok $TEST_CLASS->create($PLAYER_ID);
};

subtest 'get' => sub {
  ok(my $battle_record = $TEST_CLASS->get($PLAYER_ID));
  is $battle_record->attack_town, 0;
};

done_testing();
