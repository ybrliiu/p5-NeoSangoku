use Sangoku 'test';
use Test::Sangoku::PostgreSQL;
use Test::Sangoku::Util qw/prepare_player_model_tests/;

use Sangoku::Model::Player;
use Sangoku::Model::Country;
use Sangoku::Model::Country::ConferenceThread;

my $PSQL = Test::Sangoku::PostgreSQL->new();
my $PLAYER_ID = Sangoku::Model::Player->ADMINISTARTOR_DATA->{player}{id};
my $NEUTRAL_DATA = Sangoku::Model::Country->NEUTRAL_DATA;
my $TEST_CLASS = 'Sangoku::Model::Country::ConferenceThread';
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
    sender  => $sender,
    title   => '会議室スレッド1',
    message => '投稿テスト',
  });

  ok $OBJ->add({
    sender  => $sender,
    title   => '会議室スレッド2',
    message => '投稿テスト',
  });
};

subtest 'get' => sub {
  {
    ok(my $list = $OBJ->get);
    is @$list, 2;

    my $thread = $list->[0];
    is $thread->title, '会議室スレッド2';
  }

  {
    ok(my $list = $OBJ->get(1, 1));
    is @$list, 1;

    my $thread = $list->[0];
    is $thread->title, '会議室スレッド1';
  }
};

subtest 'delete' => sub {
  my $list = $OBJ->get;
  my $thread = $list->[0];
  ok $OBJ->delete($thread->id);
};

done_testing();
