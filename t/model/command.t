use Sangoku 'test';
use Test::Record;

use Sangoku::Model::Player::Command;

my $TEST_CLASS = 'Sangoku::Model::Command';
load $TEST_CLASS;
my $TR = Test::Record->new();

subtest 'get_list' => sub {
  ok(my $list = $TEST_CLASS->get_list);
  # diag explain $list;
};

subtest 'input' => sub {
  # prepare
  my $player_id = 'test_id';
  my $model = Sangoku::Model::Player::Command->new(id => $player_id);
  $model->init();

  ok $TEST_CLASS->input('FarmDev', {
    player_id => $player_id,
    numbers   => [0 .. 3],
  });

  my $command_list = $model->get(10);
  is $command_list->[$_]->id, 'FarmDev' for (0 .. 3);
  is $command_list->[$_]->id, 'None' for (4 .. 9);
};

done_testing();
