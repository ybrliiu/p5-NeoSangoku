use Sangoku 'test';
use Test::Sangoku::PostgreSQL;

my $TEST_CLASS = 'Sangoku::Model::Map';
load $TEST_CLASS;
my $PSQL = Test::Sangoku::PostgreSQL->new();

# テストの下準備
{
  my @models = qw/Town Country/;
  load "Sangoku::Model::$_" for @models;
  "Sangoku::Model::$_"->init() for @models;
}

subtest 'get' => sub {
  ok(my $map_data = $TEST_CLASS->get);
  is $map_data->[7][5]->name, '雷州';
};

done_testing();
