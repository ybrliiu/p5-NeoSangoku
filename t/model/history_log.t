use Sangoku 'test';
use Test::More;
use Test::Sangoku;
use Test::Record;

use Sangoku::Model::HistoryLog;

my $TR = Test::Record->new();
my $TEST_CLASS = 'Sangoku::Model::HistoryLog';

subtest 'init' => sub {
  ok $TEST_CLASS->init();
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
