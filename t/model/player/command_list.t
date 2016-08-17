use Sangoku 'test';
use Test::More;
use Test::Sangoku;
use Test::Record;
use Test::Exception;

use Sangoku::Model::Player::CommandList;

my $rec   = Test::Record->new();
my $class = 'Sangoku::Model::Player::CommandList';
my $obj;
my $player_id = 'test_player';

subtest 'new' => sub {
  $obj = $class->new(id => $player_id);
  isa_ok($obj, $class);
};

subtest 'init' => sub {
  ok $obj->init($player_id);
  
  my $list = $obj->get_all();
  is($list->[0]->name, '-');
  
  my $max = $class->CLASS->MAX();
  is($list->[$max - 1]->name, '-');

  dies_ok { $obj->at(2) };
};

subtest 'save' => sub {
  my $data = {
    name    => '',
    command => [0 .. 10],
  };
  ok $obj->save(0 => $data);
  is($obj->at(0)->name, '保存リスト0');
};

subtest 'change_name' => sub {
  ok $obj->change_name(0 => 'new_name');
  ok(my $command_list = $obj->at(0));
  is($command_list->name(), 'new_name');
  dies_ok { $obj->change_name(1) };
};

subtest 'delete' => sub {
  ok $obj->delete(0);
  dies_ok { $obj->at(0) };
};

subtest 'remove' => sub {
  ok $obj->remove();
};

done_testing();
