use Sangoku 'test';
use Test::Record;
use Test::Sangoku::PostgreSQL;
use Test::Sangoku::Util qw/prepare_player_model_tests/;

use Sangoku::Model::Player;
use Sangoku::Model::Town;
use Sangoku::Model::Town::Guards;

my $PSQL = Test::Sangoku::PostgreSQL->new();
my $TR = Test::Record->new();
my $TEST_CLASS = 'Sangoku::Model::Town::Guards';
my $OBJ;

# player のtableなども準備しないといけないので
prepare_player_model_tests();
my @PLAYERS = do {
  for my $no (1 .. 5) {
    Sangoku::Model::Player->regist({
      player => {
        id   => "test_player_$no",
        name => "テストプレイヤー$no",
        pass => 'test_test',
        icon => 0,
        town_name => '成都',
        (map { $_ => 10 } qw/force intellect leadership popular loyalty/),
        update_time => time,
      },
      country_name => '無所属',
      profile => '',
      (map {
        $_ => +{
          player_id => "test_player_$no",
          power     => 0,
        };
      } qw/weapon guard book/),
    });
  }
  @{ Sangoku::Model::Player->get_all };
};


subtest 'new' => sub {
  $OBJ = $TEST_CLASS->new(name => '開封');
  isa_ok $OBJ, $TEST_CLASS;
};

subtest 'add' => sub {
  ok $OBJ->add(head => $PLAYERS[1]->id);
  ok $OBJ->add(tail => $PLAYERS[2]->id);
  dies_ok { $OBJ->add(hoge => $PLAYERS[3]->id) };
};

subtest 'get_head_player' => sub {
  ok(my $head_player = $OBJ->get_head_player);
  is $head_player->id, 'test_player_1';
};

subtest 'get' => sub {
  ok $OBJ->add(head => $PLAYERS[3]->id);
  ok $OBJ->add(head => $PLAYERS[4]->id);
  ok(my $list = $OBJ->get);
  is @$list, 4;
  is $list->[0]->id, 'test_player_4';
  is $list->[1]->id, 'test_player_3';
  is $list->[2]->id, 'test_player_1';
  is $list->[3]->id, 'test_player_2';
};

subtest 'delete' => sub {
  ok $OBJ->delete($PLAYERS[4]->id);
  ok(my $head_player = $OBJ->get_head_player);
  is $head_player->id, 'test_player_3';
};

done_testing();
