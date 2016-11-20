use Sangoku 'test';
use Test::Record;
use Test::Sangoku::PostgreSQL;
use Test::Sangoku::Util qw/prepare_service_tests/;

my $TEST_CLASS = 'Sangoku::Model::Country';
load $TEST_CLASS;

{
  my $neutral_data = $TEST_CLASS->NEUTRAL_DATA;
  my $psql = Test::Sangoku::PostgreSQL->new();

  subtest 'create&delete' => sub {
    $TEST_CLASS->create({
      name  => $neutral_data->{name},
      color => $neutral_data->{color},
    });
    get_and_check_name();
    $TEST_CLASS->delete($neutral_data->{name});
  };
  
  subtest 'init' => sub {
    $TEST_CLASS->init();
    get_and_check_name();
    ok 1;
  };
  
  sub get_and_check_name {
    ok( my $country = $TEST_CLASS->get($neutral_data->{name}) );
    is $country->name, $neutral_data->{name};
  }
}
  
  
my $PSQL = Test::Sangoku::PostgreSQL->new();
my $TR = Test::Record->new();
prepare_service_tests();

subtest 'regist' => sub {

  package Txn {
    use Mouse;
    use Sangoku;
    with 'Sangoku::Service::Role::Base';
  }

  my $txn = Txn->txn;

  my $player_id = 'new_king';

  ok $TEST_CLASS->regist({
    name    => 'TEST COUNTRY!',
    color   => 'blue',
    king_id => $player_id,
  });

  Sangoku::Model::Player->create({
    id           => $player_id,
    name         => '王様',
    pass         => 'i_am_king',
    icon         => 0,
    town_name    => '開封',
    force        => 1,
    intellect    => 1,
    leadership   => 1,
    popular      => 200,
    loyalty      => 100,
    update_time  => time,
  });

  ok $txn->commit();
};

done_testing();
