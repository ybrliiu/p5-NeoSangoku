use Sangoku 'test';
use Test::Sangoku::PostgreSQL;
use Test::Record;
use Test::Sangoku::Util qw/prepare_service_tests/;

my $TEST_CLASS = 'Sangoku::Model::Unit';
load $TEST_CLASS;
my $PSQL = Test::Sangoku::PostgreSQL->new();
my $TR = Test::Record->new();

prepare_service_tests();

my $PLAYER_ID = Sangoku::Model::Player->ADMINISTARTOR_DATA->{player}{id};

subtest 'create' => sub {
  my $leader = Sangoku::Model::Player->get($PLAYER_ID);
  my $unit_name = 'テスト部隊';

  ok $TEST_CLASS->create({
    leader  => $leader,
    name    => $unit_name,
    message => '部隊紹介文',
  });

  ok(my $unit = $TEST_CLASS->get($unit_name, $leader->country_name));
  is $unit->id, 1;
  is $unit->name, $unit_name;

};

subtest 'regist' => sub {
};

done_testing();
