use Sangoku 'test';
use Test::Sangoku::PostgreSQL;
use Test::Sangoku::Util qw/prepare_player_model_tests/;

use Sangoku::Model::Country;
use Sangoku::Model::Country::Position;

my $TEST_CLASS = 'Sangoku::Model::Country::Position';
my $POSITION_DATA = $TEST_CLASS->NEUTRAL_POSITION_DATA;
my $PSQL = Test::Sangoku::PostgreSQL->new();

prepare_player_model_tests();

subtest 'create' => sub {
  diag explain $POSITION_DATA;
  ok $TEST_CLASS->create({
    name    => $POSITION_DATA->{name},
    king_id => undef,
  });
  ok $TEST_CLASS->delete_all();
};

subtest 'init' => sub {
  ok $TEST_CLASS->init();
};

subtest 'get' => sub {
  ok(my $position = $TEST_CLASS->get($POSITION_DATA->{name}));
  is $position->king_id, $POSITION_DATA->{king_id};
};

done_testing();
