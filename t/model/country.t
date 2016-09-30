use Sangoku 'test';
use Test::Sangoku::PostgreSQL;

use Sangoku::Model::Country;

my $TEST_CLASS = 'Sangoku::Model::Country';
my $NEUTRAL_DATA = $TEST_CLASS->NEUTRAL_DATA;
my $PSQL = Test::Sangoku::PostgreSQL->new();

subtest 'create&delete' => sub {
  $TEST_CLASS->create({
    name  => $NEUTRAL_DATA->{name},
    color => $NEUTRAL_DATA->{color},
  });
  get_and_check_name();
  $TEST_CLASS->delete($NEUTRAL_DATA->{name});
};

subtest 'init' => sub {
  $TEST_CLASS->init();
  get_and_check_name();
  ok 1;
};

sub get_and_check_name {
  ok( my $country = $TEST_CLASS->get($NEUTRAL_DATA->{name}) );
  is $country->name, $NEUTRAL_DATA->{name};
}

done_testing();
