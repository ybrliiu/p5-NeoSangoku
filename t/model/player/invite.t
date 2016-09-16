use Sangoku 'test';
use Test::More;
use Test::Sangoku;
use Test::Sangoku::PostgreSQL;
use Test::Sangoku::Util qw/prepare_player_model_tests create_test_player TEST_PLAYER_DATA/;

use Sangoku::Model::Player;
use Sangoku::Model::Player::Invite;

my $PLAYER_ID = Sangoku::Model::Player->ADMINISTARTOR_DATA->{player}{id};
my $TEST_CLASS = 'Sangoku::Model::Player::Invite';
my $OBJ;
my $PSQL = Test::Sangoku::PostgreSQL->new();

prepare_player_model_tests();
create_test_player();

subtest 'new' => sub {
  $OBJ = $TEST_CLASS->new(id => $PLAYER_ID);
  isa_ok $OBJ, $TEST_CLASS;
};

subtest 'add' => sub {
  my $sender = Sangoku::Model::Player->get($PLAYER_ID);
  my $receiver = Sangoku::Model::Player->get(TEST_PLAYER_DATA->{player}{id});

  ok $OBJ->add({
    sender   => $sender,
    receiver => $receiver,
    message  => '登用テスト',
  });

  ok $OBJ->add({
    sender   => $sender,
    receiver => $receiver,
    message  => '登用テスト2',
  });
};

subtest 'get_all' => sub {
  ok(my $list = $OBJ->get_all);
  is @$list, 4;
};

subtest 'get' => sub {
  ok(my $list = $OBJ->get);
  is @$list, 2;

  my $letter = $list->[0];
  is $letter->message, '登用テスト2';
};

done_testing();
