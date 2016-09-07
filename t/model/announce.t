use Sangoku 'test';
use Test::More;
use Test::Sangoku;
use Test::Sangoku::PostgreSQL;

use Sangoku::Util qw/date/;
use Sangoku::Model::Announce;

my $TEST_CLASS = 'Sangoku::Model::Announce';
my $PSQL = Test::Sangoku::PostgreSQL->new();

subtest 'add&get' => sub {

  my $message = <<"EOM";
・変更点
・ああああ
EOM

  ok $TEST_CLASS->add($message);
  ok $TEST_CLASS->add('mes2');
  ok $TEST_CLASS->add('mes3');
  ok $TEST_CLASS->add('mes4');

  ok(my $list = $TEST_CLASS->get);
  is @$list, 4;
  ok(my $list_limit = $TEST_CLASS->get(2));
  is @$list_limit, 2;
  is $list->[0]->date, date();
  is $list->[0]->message, 'mes4';
};

done_testing();
