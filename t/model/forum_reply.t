use Sangoku 'test';
use Test::Sangoku::PostgreSQL;

use Sangoku::Model::ForumThread;
use Sangoku::Model::ForumReply;

my $TEST_CLASS = 'Sangoku::Model::ForumReply';
my $OBJ;
my $PSQL = Test::Sangoku::PostgreSQL->new();

sub prepare_thread {
  Sangoku::Model::ForumThread->add({
    title   => '変更点',
    name    => 'hoge',
    icon    => 100,
    message => 'あああああ',
  });
  return Sangoku::Model::ForumThread->get->[0];
}

my $THREAD = prepare_thread();

subtest 'new' => sub {
  $OBJ = $TEST_CLASS->new(thread_id => $THREAD->id);
  isa_ok $OBJ, $TEST_CLASS;
};

subtest 'add&get' => sub {

  ok $OBJ->add({
    name    => 'ほげええええ',
    icon    => 100,
    message => '返信1',
  });
  ok $OBJ->add({
    name    => 'piyo',
    icon    => 10,
    message => 'あばばば',
  });

  ok(my $list = $OBJ->get);
  is @$list, 2;

  my $thread = $list->[0];
  is $thread->message, 'あばばば';
};

done_testing();
