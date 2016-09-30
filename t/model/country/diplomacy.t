use Sangoku 'test';
use Test::Sangoku::PostgreSQL;
use Test::Sangoku::Util qw/prepare_country_model_tests/;

use Sangoku::Model::Country;
use Sangoku::Model::Country::Diplomacy;

my $NEUTRAL_DATA = Sangoku::Model::Country->NEUTRAL_DATA;
my $TEST_CLASS = 'Sangoku::Model::Country::Diplomacy';
my ($OBJ, $OBJ2);
my $MONTH_AND_YEARS_NUM = 86001;
my $PSQL = Test::Sangoku::PostgreSQL->new();

prepare_country_model_tests();
my $TEST_COUNTRY = do {
  Sangoku::Model::Country->create({
    name    => 'テスト国家',
    color   => 'black',
  });
  Sangoku::Model::Country->get('テスト国家');
};

subtest 'new' => sub {
  $OBJ = $TEST_CLASS->new(name => $NEUTRAL_DATA->{name});
  isa_ok $OBJ, $TEST_CLASS;
  $OBJ2 = $TEST_CLASS->new(name => $TEST_COUNTRY->name);

  ok !$OBJ->can_invation($TEST_COUNTRY->name, $MONTH_AND_YEARS_NUM);
};

subtest 'add' => sub {
  ok $OBJ->add({
    type => 'war',
    receive_country => $TEST_COUNTRY->name,
    start_year => 855,
    start_month => 12,
  });

  dies_ok {
    $OBJ2->add({
      type => 'war',
      receive_country => $NEUTRAL_DATA->{name},
      start_year => 855,
      start_month => 12,
    });
  };

  dies_ok {
    $OBJ2->add({
      type => 'war',
      receive_country => $TEST_COUNTRY->name,
      start_year => 855,
      start_month => 12,
    });
  };

};

subtest 'can_invation' => sub {
  ok $OBJ->can_invation($TEST_COUNTRY->name, $MONTH_AND_YEARS_NUM);
  ok !$OBJ->can_invation($TEST_COUNTRY->name, $MONTH_AND_YEARS_NUM - 1000);
  ok $OBJ2->can_invation($NEUTRAL_DATA->{name}, $MONTH_AND_YEARS_NUM);
};

subtest 'get_diplomacy_state' => sub {
  ok(my $list = $OBJ->get_diplomacy_state);
  is @$list, 1;
};

subtest 'get&delete' => sub {
  ok(my $diplomacy = $TEST_CLASS->get({
    type => 'war',
    request_country => $NEUTRAL_DATA->{name},
    receive_country => $TEST_COUNTRY->name,
  }) );
  ok $diplomacy->type, 'war';

  ok $TEST_CLASS->delete({
    type => 'war',
    request_country => $NEUTRAL_DATA->{name},
    receive_country => $TEST_COUNTRY->name,
  });
};

done_testing();
