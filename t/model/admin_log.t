use Sangoku 'test';
use Test::Record;

use Sangoku::Model::AdminLog;

my $TR = Test::Record->new();
my $TEST_CLASS = 'Sangoku::Model::AdminLog';

subtest 'init' => sub {
  $TEST_CLASS->init();
  my $list = $TEST_CLASS->get_all();
  ok !@$list;
};

subtest 'add' => sub {
  ok $TEST_CLASS->add('this is test log.');
  ok(my $list = $TEST_CLASS->get_all);
  like $list->[0], qr/this is test log./;
};

subtest 'remove' => sub {
  ok $TEST_CLASS->remove();
};

done_testing();
