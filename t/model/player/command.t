use Sangoku 'test';
use Test::More;
use Test::Sangoku;
use Test::Record;

use Sangoku::Model::Player::Command;

my $TR = Test::Record->new();
my $TEST_CLASS = 'Sangoku::Model::Player::Command';
my $OBJ;
my $PLAYER_ID = 'test_player';

subtest 'new' => sub {
  $OBJ = $TEST_CLASS->new(id => $PLAYER_ID);
  isa_ok($OBJ, $TEST_CLASS);
};

subtest 'init' => sub {
  ok $OBJ->init($PLAYER_ID);
  
  my $list = $OBJ->get_all();
  my $none = $OBJ->NONE_DATA;
  is($list->[0]->id, $none->{id});
  
  my $max = $TEST_CLASS->CLASS->MAX();
  is($list->[$max - 1]->id, $none->{id});
};

subtest 'input' => sub {
  ok $OBJ->input(undef, [0 .. 10]);
};

subtest 'remove' => sub {
  ok $OBJ->remove();
};

done_testing();
