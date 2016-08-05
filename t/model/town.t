use Jikkoku 'test';
use Test::More;
use Test::Jikkoku;
use Test::Jikkoku::PostgreSQL;

use Jikkoku::Model::Town;

my $class = 'Jikkoku::Model::Town';
Test::Jikkoku::PostgreSQL->construct();

# テストの下準備
{
  use Jikkoku::Model::Country;
  Jikkoku::Model::Country->init();
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
