use Sangoku 'test';
use Test::More;
use Test::Sangoku;
use Test::Sangoku::PostgreSQL;
use Test::Sangoku::Util qw/prepare_player_model_tests/;

use Sangoku::Model::Player;
use Sangoku::Model::Country;
use Sangoku::Model::Country::Law;

my $PSQL = Test::Sangoku::PostgreSQL->new();
my $PLAYER_ID = Sangoku::Model::Player->ADMINISTARTOR_DATA->{player}{id};
my $NEUTRAL_DATA = Sangoku::Model::Country->NEUTRAL_DATA;
my $TEST_CLASS = 'Sangoku::Model::Country::Law';
my $OBJ;

# player のtableなども準備しないといけないので
prepare_player_model_tests();

subtest 'new' => sub {
  $OBJ = $TEST_CLASS->new(name => $NEUTRAL_DATA->{name});
  isa_ok $OBJ, $TEST_CLASS;
};

subtest 'add' => sub {
  my $sender = Sangoku::Model::Player->get($PLAYER_ID);

  ok $OBJ->add({
    sender   => $sender,
    title    => 'ルール',
    message  => 'あああ',
  });

  ok $OBJ->add({
    sender   => $sender,
    title    => '同盟',
    message  => '相互不可侵',
  });
};

subtest 'get_all' => sub {
  ok(my $list = $OBJ->get_all);
  is @$list, 2;
};

subtest 'get' => sub {
  ok(my $list = $OBJ->get);
  is @$list, 2;
  my $law = $list->[0];
  is $law->title, '同盟';
};

done_testing();
