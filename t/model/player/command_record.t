use Sangoku 'test';
use Test::Sangoku::PostgreSQL;
use Test::Sangoku::Util qw/prepare_player_model_tests create_test_player TEST_PLAYER_DATA/;

use Sangoku::Model::Player;
use Sangoku::Model::Player::CommandRecord;

my $PLAYER_ID = Sangoku::Model::Player->ADMINISTARTOR_DATA->{player}{id};
my $TEST_CLASS = 'Sangoku::Model::Player::CommandRecord';
my $OBJ;
my $PSQL = Test::Sangoku::PostgreSQL->new();

prepare_player_model_tests();
create_test_player();

subtest 'new' => sub {
  $OBJ = $TEST_CLASS->new(id => $PLAYER_ID);
  isa_ok $OBJ, $TEST_CLASS;
};

subtest 'add' => sub {
  ok $OBJ->add('何もしない');
  ok $OBJ->add('商業開発');
};

subtest 'count' => sub {
  $OBJ->count('何もしない');
  $OBJ->count('農業開発');
  ok 1;
};

subtest 'get' => sub {
  ok(my $list = $OBJ->get);
  is @$list, 3;
};

subtest 'get_from_command_name' => sub {
  my $model = $TEST_CLASS->new(id => TEST_PLAYER_DATA->{player}{id});
  $model->count('農業開発');

  ok(my $list = $OBJ->get_from_command_name('農業開発'));
  is @$list, 2;
};

done_testing();
