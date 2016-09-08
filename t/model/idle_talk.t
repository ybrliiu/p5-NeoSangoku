use Sangoku 'test';
use Test::More;
use Test::Sangoku;
use Test::Sangoku::PostgreSQL;

use Sangoku::Model::IdleTalk;

my $TEST_CLASS = 'Sangoku::Model::IdleTalk';
my $PSQL = Test::Sangoku::PostgreSQL->new();

subtest 'add&get' => sub {

  ok $TEST_CLASS->add({
    name    => 'ほげええええ',
    icon    => 100,
    message => '書いていきしょう',
  });
  ok $TEST_CLASS->add({
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
