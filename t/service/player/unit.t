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
my $UNIT_NAME = 'テスト部隊';
my $UNIT_ID = '';
my $JOIN_PLAYER;

subtest 'create' => sub {

  my $unit_message = '部隊メッセージ';

  ok $TEST_CLASS->create({
    player_id => $LEADER_ID,
    name      => $UNIT_NAME,
    message   => $unit_message,
  });

  my $unit = Sangoku::Model::Unit->get($UNIT_NAME, "無所属");
  $UNIT_ID = $unit->id;
  is $unit->leader_id, $LEADER_ID;
  is $unit->name, $UNIT_NAME;
  is $unit->message, $unit_message;

};

subtest 'join_and_quit' => sub {

  my $join_player_id = TEST_PLAYER_DATA->{player}{id};

  join_unit($join_player_id);

  $JOIN_PLAYER = Sangoku::Model::Player->get($join_player_id);
  is $JOIN_PLAYER->unit_id, $UNIT_ID;

  ok $TEST_CLASS->quit($join_player_id);
  $JOIN_PLAYER = $JOIN_PLAYER->refetch();
  ok !$JOIN_PLAYER->unit_id;

  join_unit($join_player_id);

};

sub join_unit {
  my ($join_player_id) = @_;
  ok $TEST_CLASS->join({
    player_id => $join_player_id,
    unit_id   => $UNIT_ID,
  });
}

subtest 'leader_tests' => sub {

  my $unit = Sangoku::Model::Unit->get($UNIT_ID);

  ok $TEST_CLASS->switch_join_permit($LEADER_ID) for 0 .. 1;

  my $new_message = '変更したで';
  ok $TEST_CLASS->change_info({
    player_id => $LEADER_ID,
    name      => $UNIT_NAME,
    message   => $new_message,
  });
  $unit = $unit->refetch;
  is $unit->message, $new_message;

  ok $TEST_CLASS->fire({
    player_id => $LEADER_ID,
    target_id => $JOIN_PLAYER->id,
  });
  ok !$JOIN_PLAYER->is_belong_unit;

  ok $TEST_CLASS->break($LEADER_ID);
  my $leader = Sangoku::Model::Player->get($LEADER_ID);
  ok !$leader->unit_id;

};

done_testing();
