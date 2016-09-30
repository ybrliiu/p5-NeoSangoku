use Sangoku 'test';
use Test::Record;

use Sangoku::Model::Player::CommandList;

my $TR = Test::Record->new();
my $TEST_CLASS = 'Sangoku::Model::Player::CommandList';
my $OBJ;
my $PLAYER_ID = 'test_player';

subtest 'new' => sub {
  $OBJ = $TEST_CLASS->new(id => $PLAYER_ID);
  isa_ok($OBJ, $TEST_CLASS);
};

subtest 'init' => sub {
  ok $OBJ->init($PLAYER_ID);
  
  my $list = $OBJ->get_all();
  my $default_name = $OBJ->CLASS->DEFAULT_NAME;
  is($list->[0]->name, $default_name);
  
  my $max = $TEST_CLASS->CLASS->MAX();
  is($list->[$max - 1]->name, $default_name);

  dies_ok { $OBJ->at(2) };
};

subtest 'save' => sub {
  my $data = {
    name    => '',
    command => [0 .. 10],
  };
  ok $OBJ->save(0 => $data);
  is($OBJ->at(0)->name, '保存リスト0');
};

subtest 'change_name' => sub {
  ok $OBJ->change_name(0 => 'new_name');
  ok(my $command_list = $OBJ->at(0));
  is($command_list->name(), 'new_name');
  dies_ok { $OBJ->change_name(1) };
};

subtest 'delete' => sub {
  ok $OBJ->delete(0);
  dies_ok { $OBJ->at(0) };
};

subtest 'remove' => sub {
  ok $OBJ->remove();
};

done_testing();
