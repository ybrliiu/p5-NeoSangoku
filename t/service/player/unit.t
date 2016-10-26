use Sangoku 'test';
use Test::Sangoku::PostgreSQL;
use Test::Record;
use Test::Sangoku::Util qw/TEST_PLAYER_DATA prepare_service_tests/;

my $TEST_CLASS = 'Sangoku::Service::Player::Unit';
load $TEST_CLASS;
my $PSQL = Test::Sangoku::PostgreSQL->new();
my $TR = Test::Record->new();
prepare_service_tests();

my $LEADER_ID = Sangoku::Model::Player->ADMINISTARTOR_DATA->{player}{id};

subtest 'create' => sub {

  my $unit_name = 'テスト部隊';
  my $unit_mes  = '部隊メッセージ';

  ok $TEST_CLASS->create({
    player_id => $LEADER_ID,
    name      => $unit_name,
    message   => $unit_mes,
  });

  my $unit = Sangoku::Model::Unit->get($LEADER_ID);
  is $unit->name, $unit_name;
  is $unit->message, $unit_mes;

  subtest 'switch_join_permit' => sub {
    ok $TEST_CLASS->switch_join_permit({
      player_id => $LEADER_ID,
      unit_id   => $unit->id,
    }) for 0 .. 1;
  };

};

subtest 'join_and_quit' => sub {

  my $join_player_id = TEST_PLAYER_DATA->{player}{id};

  ok $TEST_CLASS->join({
    player_id => $join_player_id,
    unit_id   => $LEADER_ID,
  });

  my $join_player = Sangoku::Model::Player->get($join_player_id);
  is $join_player->unit_id, $LEADER_ID;

  ok $TEST_CLASS->quit($join_player_id);
  $join_player = $join_player->refetch();
  is $join_player->unit_id, '';

};

subtest 'break' => sub {

  ok $TEST_CLASS->break({
    player_id => $LEADER_ID,
    unit_id   => $LEADER_ID,
  });

  my $leader = Sangoku::Model::Player->get($LEADER_ID);
  is $leader->unit_id, '';

};

done_testing();
