use Sangoku 'test';
use Test::More;
use Test::Sangoku;
use Test::Record;
use Test::Sangoku::PostgreSQL;

use Sangoku::Service::Admin::ResetGame;

my $TEST_CLASS = 'Sangoku::Service::Admin::ResetGame';
my $PSQL = Test::Sangoku::PostgreSQL->new();
my $TR = Test::Record->new();

subtest 'reset_game' => sub {
  $TEST_CLASS->reset_game(1000000);
  ok 1;
};

done_testing();
