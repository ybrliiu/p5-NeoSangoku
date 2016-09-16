use Sangoku 'test';
use Test::More;
use Test::Sangoku;
use Test::Record;

use Sangoku::Model::Site;

my $TR = Test::Record->new();
my $TEST_CLASS = 'Sangoku::Model::Site';
my $START_TIME = 1382987389;

subtest 'init' => sub {
  ok $TEST_CLASS->init($START_TIME);
};

subtest 'get' => sub {
  ok(my $site = $TEST_CLASS->get);
  is $site->term, 0;
  is $site->start_time, $START_TIME;
};

subtest 'init_2' => sub {
  $TEST_CLASS->init($START_TIME + 10000);
  ok 1;
};

subtest 'get' => sub {
  ok(my $site = $TEST_CLASS->get);
  is $site->term, 1;
  is $site->start_time, $START_TIME + 10000;
};

done_testing();
