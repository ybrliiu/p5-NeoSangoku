use Sangoku 'test';
use Test::More;
use Test::Sangoku;
use Test::Sangoku::PostgreSQL;

use Sangoku::Model::Town;

my $class = 'Sangoku::Model::Town';
Test::Sangoku::PostgreSQL->construct();

# テストの下準備
{
  use Sangoku::Model::Country;
  Sangoku::Model::Country->init();
}

subtest 'init' => sub {
  $class->init();
  ok 1;
};

subtest 'get' => sub {
  ok(my $town = $class->get('金陵'));
  is $town->name, '金陵';
};

done_testing();
