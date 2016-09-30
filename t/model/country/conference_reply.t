use Sangoku 'test';
use Test::Sangoku::PostgreSQL;
use Test::Sangoku::Util qw/prepare_player_model_tests/;

use Sangoku::Model::Player;
use Sangoku::Model::Country;
use Sangoku::Model::Country::ConferenceThread;
use Sangoku::Model::Country::ConferenceReply;

my $PSQL = Test::Sangoku::PostgreSQL->new();
my $PLAYER_ID = Sangoku::Model::Player->ADMINISTARTOR_DATA->{player}{id};
my $NEUTRAL_DATA = Sangoku::Model::Country->NEUTRAL_DATA;
my $TEST_CLASS = 'Sangoku::Model::Country::ConferenceReply';
my $OBJ;

# player のtableなども準備しないといけないので
prepare_player_model_tests();

sub prepare_thread {
  my $thread_model = Sangoku::Model::Country::ConferenceThread->new(name => '無所属');
  my $sender = Sangoku::Model::Player->get($PLAYER_ID);
  $thread_model->add({
    sender  => $sender,
    title   => '会議室スレッド1',
    message => '投稿テスト',
  });
  return $thread_model->get->[0];
}

my $THREAD = prepare_thread();

subtest 'new' => sub {
  $OBJ = $TEST_CLASS->new(
    name      => $NEUTRAL_DATA->{name},
    thread_id => $THREAD->id,
  );
  isa_ok $OBJ, $TEST_CLASS;
};

subtest 'add' => sub {
  my $sender = Sangoku::Model::Player->get($PLAYER_ID);

  ok $OBJ->add({
    sender  => $sender,
    message => '返信テスト',
  });

  ok $OBJ->add({
    sender  => $sender,
    message => '返信テスト2',
  });
};

subtest 'get' => sub {
  ok(my $list = $OBJ->get);
  is @$list, 2;

  my $reply = $list->[0];
  is $reply->message, '返信テスト2';
};

subtest 'delete' => sub {
  ok $OBJ->delete();
  ok(my $list = $OBJ->get);
  is @$list, 0;
};

done_testing();
