use Sangoku 'test';
use Test::More;
use Test::Sangoku;
use Test::Sangoku::PostgreSQL;

use Sangoku::Model::Player;

my $class = 'Sangoku::Model::Player';
Test::Sangoku::PostgreSQL->construct();

# テストの下準備
{
  use Sangoku::Model::Country;
  use Sangoku::Model::Town;
  Sangoku::Model::Country->init();
  Sangoku::Model::Town->init();
}

subtest 'init' => sub {
  $class->init();
  ok 1;
};

subtest 'get' => sub {
  ok(my $town = $class->get('administrator'));
  is $town->name, '管理人';
};

done_testing();
