use Sangoku 'test';
use Test::More;
use Test::Sangoku;
use Test::Record;

use Sangoku::Model::Player::Command;

my $rec   = Test::Record->new();
my $class = 'Sangoku::Model::Player::Command';
my $obj;
my $player_id = 'test_player';

subtest 'new' => sub {
  $obj = $class->new(id => $player_id);
  isa_ok($obj, $class);
};

subtest 'init' => sub {
  ok $obj->init($player_id);
  
  my $list = $obj->get_all();
  is($list->[0]->id, 'None');
  
  my $max = $class->CLASS->max();
  is($list->[$max - 1]->id, 'None');
};

subtest 'input' => sub {
  ok $obj->input(undef, [0 .. 10]);
};

subtest 'remove' => sub {
  ok $obj->remove();
};

done_testing();
