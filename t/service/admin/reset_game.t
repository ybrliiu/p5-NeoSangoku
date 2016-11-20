use Sangoku 'test';
use Test::Record;
use Test::Sangoku::PostgreSQL;

use Sangoku::Service::Admin::ResetGame;

my $TEST_CLASS = 'Sangoku::Service::Admin::ResetGame';
my $PSQL = Test::Sangoku::PostgreSQL->new();
my $TR = Test::Record->new();

subtest 'reset_game' => sub {
  lives_ok { $TEST_CLASS->init_data_all('2016年1月8日19時') };
  lives_ok { $TEST_CLASS->reset_game('2016年10月20日20時') };
};

done_testing();
