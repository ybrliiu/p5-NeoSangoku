use Sangoku 'test';
use Test::More;
use Test::Exception;
use Test::Sangoku;
use Test::Record;
use Test::Sangoku::PostgreSQL;

use Sangoku::Service::Admin::ResetGame;

my $TEST_CLASS = 'Sangoku::Service::Admin::ResetGame';
my $PSQL = Test::Sangoku::PostgreSQL->new();
my $TR = Test::Record->new();

subtest 'reset_game' => sub {
  lives_ok { $TEST_CLASS->init_data_all(1000000) };
  lives_ok { $TEST_CLASS->reset_game(1000000) };
};

done_testing();
