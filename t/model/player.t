use Sangoku 'test';
use Test::More;
use Test::Sangoku;
use Test::Sangoku::PostgreSQL;

use Sangoku::Model::Player;

use Config::PL;
use Sangoku::Util qw/project_root_dir/;

my $class = 'Sangoku::Model::Player';
Test::Sangoku::PostgreSQL->construct();

# テストの下準備
{
  eval "require Sangoku::Model::$_" for qw/Country Town/;
  "Sangoku::Model::$_"->init() for qw/Country Town/;
}

subtest 'init' => sub {
  $class->init();
  ok 1;
};

subtest 'get' => sub {
  my $path = project_root_dir() . 'etc/config/site.conf';
  my $site = config_do($path)->{'site'};
  my $admin_id = $site->{admin_id};
  ok(my $town = $class->get($admin_id));
  is $town->name, '管理人';
};

done_testing();
