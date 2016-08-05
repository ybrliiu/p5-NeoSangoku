use Jikkoku 'test';
use Test::More;
use Test::Jikkoku;
use Test::Jikkoku::PostgreSQL;

use Jikkoku::Model::Country;

my $class = 'Jikkoku::Model::Country';
Test::Jikkoku::PostgreSQL->construct();

subtest 'init' => sub {
  ok $class->init();
};

subtest 'get' => sub {
  ok(my $country = $class->get('無所属'));
  is $country->name, '無所属';
};

done_testing();
