use Sangoku 'test';
use Test::Sangoku::PostgreSQL;
use Test::Sangoku::Util qw/prepare_player_model_tests create_test_player TEST_PLAYER_DATA/;

use Sangoku::Model::Player; 
use Sangoku::Model::LoginList;

my $TEST_CLASS = 'Sangoku::Model::LoginList';
my $PSQL = Test::Sangoku::PostgreSQL->new();
my $PLAYER_ID = Sangoku::Model::Player->ADMINISTARTOR_DATA->{player}{id};

prepare_player_model_tests();
create_test_player();

subtest 'get' => sub {
  my $player = Sangoku::Model::Player->get($PLAYER_ID);
  ok $TEST_CLASS->get($player);

  my $player2 = Sangoku::Model::Player->get(TEST_PLAYER_DATA->{player}{id});
  ok(my $list = $TEST_CLASS->get($player2));
};

subtest 'get_all' => sub {
  ok(my $list = $TEST_CLASS->get_all);
  is @$list, 2;
};

done_testing();
