use Sangoku 'test';
use Test::More;
use Test::Sangoku;
use Test::Sangoku::PostgreSQL;

use Sangoku::Model::Site;

my $TEST_CLASS = 'Sangoku::Model::Site';
my $PSQL = Test::Sangoku::PostgreSQL->new();
my $START_TIME = 1382987389;

subtest 'init' => sub {
  ok $TEST_CLASS->init($START_TIME);
};

subtest 'get' => sub {
  ok(my $site = $TEST_CLASS->get);
  is $site->id, 0;
  is $site->term, 0;
  is $site->start_time, $START_TIME;
};

subtest 'init_2' => sub {
  ok $TEST_CLASS->init($START_TIME + 10000);
};

subtest 'get' => sub {
  ok(my $site = $TEST_CLASS->get);
  is $site->id, 0;
  is $site->term, 1;
  is $site->start_time, $START_TIME + 10000;
};

done_testing();
