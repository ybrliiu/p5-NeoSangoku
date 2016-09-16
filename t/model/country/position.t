use Sangoku 'test';
use Test::More;
use Test::Sangoku;
use Test::Sangoku::PostgreSQL;
use Test::Sangoku::Util qw/prepare_country_model_tests/;

use Sangoku::Model::Country;
use Sangoku::Model::Country::Position;

my $NEUTRAL_DATA = Sangoku::Model::Country->NEUTRAL_DATA;
my $TEST_CLASS = 'Sangoku::Model::Country::Position';
my $PSQL = Test::Sangoku::PostgreSQL->new();

prepare_country_model_tests();

subtest 'create' => sub {
  diag $NEUTRAL_DATA->{king_id};
  ok $TEST_CLASS->create({
    name    => $NEUTRAL_DATA->{name},
    king_id => $NEUTRAL_DATA->{king_id},
  });
};

subtest 'get' => sub {
  ok(my $position = $TEST_CLASS->get($NEUTRAL_DATA->{name}));
  is $position->king_id, '';
};

done_testing();
