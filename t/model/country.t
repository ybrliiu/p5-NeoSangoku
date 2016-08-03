use Jikkoku 'test';
use Test::More;
use Test::Jikkoku;
use Test::Jikkoku::PostgreSQL;

use Jikkoku::Model::Country;

my $class = 'Jikkoku::Model::Country';
Test::Jikkoku::PostgreSQL->construct();

subtest 'get' => sub {
  ok $class->init();
  my $country = $class->get('無所属');
  diag $country->name;
};

done_testing;
