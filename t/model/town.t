use Sangoku 'test';
use Test::Sangoku::PostgreSQL;

my $TEST_CLASS = 'Sangoku::Model::Town';
load $TEST_CLASS;
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
  is $map_data->[7][5]->name, '雷州';
};

done_testing();
