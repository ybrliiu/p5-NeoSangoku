use Sangoku 'test';
use Test::Sangoku::PostgreSQL;
use Test::Sangoku::Util qw/prepare_player_model_tests/;

use Sangoku::Model::Player;
use Sangoku::Model::Player::Letter;
use Sangoku::Model::Unit;
use Sangoku::Model::Unit::Letter;

my $PSQL = Test::Sangoku::PostgreSQL->new();
my $TEST_CLASS = 'Sangoku::Model::Unit::Letter';
my $OBJ;

prepare_player_model_tests({regist => 1});

my $UNIT_NAME = 'テスト部隊';
my $PLAYER_ID = Sangoku::Model::Player->ADMINISTARTOR_DATA->{player}{id};
my $LEADER    = Sangoku::Model::Player->get($PLAYER_ID);
Sangoku::Model::Unit->create({
  leader => $LEADER,
  name   => $UNIT_NAME,
  message => '部隊説明文',
});

subtest 'new' => sub {
  my $unit = Sangoku::Model::Unit->get($UNIT_NAME, $LEADER->country_name);
  $OBJ = $TEST_CLASS->new({
    id   => $unit->id,
    name => $unit->name,
  });
  isa_ok $OBJ, $TEST_CLASS;
};

subtest 'add' => sub {
  my $sender = Sangoku::Model::Player->get($PLAYER_ID);

  ok $OBJ->add({
    sender   => $sender,
    message  => '手紙テスト',
  });

  ok $OBJ->add({
    sender   => $sender,
    message  => 'テスト2',
  });
};

subtest 'get_all' => sub {
  ok(my $list = $OBJ->get_all);
  is @$list, 2;
};

subtest 'get' => sub {

  {
    ok(my $list = $OBJ->get);
    is @$list, 2;
    my $letter = $list->[0];
    is $letter->message, 'テスト2';
  }

  {
    ok(my $list = Sangoku::Model::Player::Letter->new(id => $PLAYER_ID)->get());
    is @$list, 2;
    my $letter = $list->[0];
    is $letter->message, 'テスト2';
  }

};

done_testing();
