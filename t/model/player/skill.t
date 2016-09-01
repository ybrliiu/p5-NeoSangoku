use Sangoku 'test';
use Test::More;
use Test::Sangoku;
use Test::Sangoku::PostgreSQL;
use Test::Sangoku::Util qw/prepare_player_model_tests/;

use Sangoku::Model::Player;
use Sangoku::Model::Player::Skill;

my $PLAYER_ID = Sangoku::Model::Player->ADMINISTARTOR_DATA->{player}{id};
my $TEST_CLASS = 'Sangoku::Model::Player::Skill';
my $OBJ;
my $PSQL = Test::Sangoku::PostgreSQL->new();

prepare_player_model_tests();

subtest 'init' => sub {
  $TEST_CLASS->init();
  ok 1;
};

subtest 'new' => sub {
  $OBJ = $TEST_CLASS->new(id => $PLAYER_ID);
  isa_ok $OBJ, $TEST_CLASS;
};

subtest 'add' => sub {
  ok $OBJ->add(attack_town => 1);
  ok $OBJ->add(call_up_farmer => 1);
};

subtest 'get' => sub {
  ok(my $list = $OBJ->get);
  is @$list, 2;
};

subtest 'get_skills' => sub {
  ok(my $list = $OBJ->get_skills('attack_town'));
  is @$list, 1;

  my $row = $list->[0];
  is $row->skill_name, 1;
  is $row->skill_category, 'attack_town';
};

done_testing();
