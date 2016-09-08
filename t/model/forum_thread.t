use Sangoku 'test';
use Test::More;
use Test::Sangoku;
use Test::Sangoku::PostgreSQL;

use Sangoku::Model::ForumThread;

my $TEST_CLASS = 'Sangoku::Model::ForumThread';
my $PSQL = Test::Sangoku::PostgreSQL->new();

subtest 'add&get' => sub {

  ok $TEST_CLASS->add({
    title   => '来期への要望',
    name    => 'ほげええええ',
    icon    => 100,
    message => '書いていきしょう',
  });
  ok $TEST_CLASS->add({
    title   => '来期への要望2',
    name    => 'ぴよおおおお',
    icon    => 10,
    message => 'あばばば',
  });

  ok(my $list = $TEST_CLASS->get);
  is @$list, 2;

  my $thread = $list->[0];
  is $thread->message, 'あばばば';
};

done_testing();
