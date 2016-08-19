use Sangoku 'test';
use Test::More;
use Test::Sangoku;
use Test::Record;

use Sangoku::Model::Player::CommandLog;

my $rec   = Test::Record->new();
my $class = 'Sangoku::Model::Player::CommandLog';
my $obj;
my $player_id = 'test_player';

subtest 'new' => sub {
  $obj = $class->new(id => $player_id);
  isa_ok($obj, $class);
};

subtest 'init' => sub {
  ok $obj->init($player_id);
  my $list = $obj->get_all();
  ok !@$list;
};

subtest 'add' => sub {
  ok $obj->add('this is test log.');
  ok(my $list = $obj->get_all);
  like $list->[0], qr/this is test log./;
};

subtest 'remove' => sub {
  ok $obj->remove();
};

done_testing();
