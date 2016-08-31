use Sangoku 'test';
use Test::More;
use Test::Sangoku;
use Test::Record;

use Sangoku::Model::Player::CommandLog;

my $TR = Test::Record->new();
my $TEST_CLASS = 'Sangoku::Model::Player::CommandLog';
my $OBJ;
my $PLAYER_ID = 'test_player';

subtest 'new' => sub {
  $OBJ = $TEST_CLASS->new(id => $PLAYER_ID);
  isa_ok($OBJ, $TEST_CLASS);
};

subtest 'init' => sub {
  ok $OBJ->init($PLAYER_ID);
  my $list = $OBJ->get_all();
  ok !@$list;
};

subtest 'add' => sub {
  ok $OBJ->add('this is test log.');
  ok(my $list = $OBJ->get_all);
  like $list->[0], qr/this is test log./;
};

subtest 'remove' => sub {
  ok $OBJ->remove();
};

done_testing();
