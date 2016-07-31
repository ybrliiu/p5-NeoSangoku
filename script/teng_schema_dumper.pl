# Jikkoku::DB::Schema クラスを出力するスクリプト

use FindBin;
use lib "$FindBin::Bin/../lib";
use Jikkoku;

use DBI;
use Teng::Schema::Dumper;
use Jikkoku::Util qw/project_root_dir/;
use Config::PL;

my $info = config_do( project_root_dir() . 'etc/config/db.conf');

my $dbh = DBI->connect(@{ $info->{connect_info} });
print Teng::Schema::Dumper->dump(
  dbh => $dbh,
  namespace => 'Jikkoku::DB',
);
