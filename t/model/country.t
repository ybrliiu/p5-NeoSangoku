use Sangoku 'test';
use Test::More;
use Test::Sangoku;
use Test::Sangoku::PostgreSQL;

use Sangoku::Model::Country;

my $TEST_CLASS = 'Sangoku::Model::Country';
my $PSQL  = Test::Sangoku::PostgreSQL->new();

subtest 'init' => sub {
  $TEST_CLASS->init();
  ok 1;
};

subtest 'get' => sub {
  ok(my $country = $TEST_CLASS->get('無所属'));
  is $country->name, '無所属';
};

done_testing();
