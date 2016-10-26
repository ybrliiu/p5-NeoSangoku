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
my $LEADER = Sangoku::Model::Player->get($PLAYER_ID);

subtest 'create' => sub {
  my $unit_name = 'テスト部隊';

  ok $TEST_CLASS->create({
    leader  => $LEADER,
    name    => $unit_name,
    message => '部隊紹介文',
  });

  ok(my $unit = $TEST_CLASS->get($unit_name, $LEADER->country_name));
  is $unit->id, 1;
  is $unit->name, $unit_name;

  ok $TEST_CLASS->delete($unit->id);

};

subtest 'regist' => sub {
  my $unit_name = 'テスト部隊2';

  ok $TEST_CLASS->regist({
    leader  => $LEADER,
    name    => $unit_name,
    message => "ああああ",
  });

  my $member = Sangoku::Model::Unit::Members->get_by_player_id($LEADER->id);
  my $unit = $TEST_CLASS->get($member->unit_id);

  is $unit->name, $unit_name;

};

done_testing();
