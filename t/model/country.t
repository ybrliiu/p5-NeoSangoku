use Sangoku 'test';
use Test::More;
use Test::Sangoku;
use Test::Sangoku::PostgreSQL;

use Sangoku::Model::Country;

my $class = 'Sangoku::Model::Country';
Test::Sangoku::PostgreSQL->construct();

subtest 'init' => sub {
  ok $class->init();
};

subtest 'get' => sub {
  ok(my $country = $class->get('無所属'));
  is $country->name, '無所属';
};

done_testing();
