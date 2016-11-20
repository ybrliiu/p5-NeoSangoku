use Sangoku 'test';
use Test::Sangoku::PostgreSQL;
use Test::Record;
use Test::Sangoku::Util qw/prepare_service_tests/;

use Sangoku::Model::Unit;
my $TEST_CLASS = 'Sangoku::Model::Unit::Members';
load $TEST_CLASS;
my $PSQL = Test::Sangoku::PostgreSQL->new();
my $TR = Test::Record->new();

prepare_service_tests();

my $PLAYER_ID = Sangoku::Model::Player->ADMINISTARTOR_DATA->{player}{id};

subtest 'add&get' => sub {

  my $leader = Sangoku::Model::Player->get_joined_to_country_members($PLAYER_ID);
  my $unit_name = 'テスト部隊';
  Sangoku::Model::Unit->create({
    leader  => $leader,
    name    => $unit_name,
    message => '部隊紹介文',
  });
  my $unit = Sangoku::Model::Unit->get($unit_name, $leader->country_name);

  ok(my $model = $TEST_CLASS->new(id => $unit->id));
  ok $model->add($leader);
  ok(my $members = $model->get);
  is @$members, 1;
  my $member = $members->[0];
  is $member->player_id, $leader->id;
  is $member->player_name, $leader->name;
  is $member->unit_id, $unit->id;

  {
    my $member = $TEST_CLASS->get_by_player_id($leader->id);
    is $member->unit_id, $unit->id;
  }

};

done_testing();
