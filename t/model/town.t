use Sangoku 'test';
use Test::Sangoku::PostgreSQL;

use Sangoku::Model::Town;

my $TEST_CLASS = 'Sangoku::Model::Town';
my $PSQL = Test::Sangoku::PostgreSQL->new();

# テストの下準備
{
  use Sangoku::Model::Country;
  Sangoku::Model::Country->init();
}

subtest 'init' => sub {
  $TEST_CLASS->init();
  ok 1;
};

subtest 'get' => sub {
  ok(my $town = $TEST_CLASS->get('金陵'));
  is $town->name, '金陵';
};

subtest 'get_all_for_map' => sub {
  ok(my $map_data = $TEST_CLASS->get_all_for_map);
  diag explain $map_data;
};

done_testing();
