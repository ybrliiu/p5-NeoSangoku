# Sangoku::DB::Schema クラスを出力するスクリプト

use FindBin;
use lib "$FindBin::Bin/../lib";
use Sangoku;

use DBI;
use Teng::Schema::Dumper;
use Sangoku::Util qw/load_config/;

my $info = load_config('etc/config/db.conf');

my $dbh = DBI->connect(@{ $info->{connect_info} });
print Teng::Schema::Dumper->dump(
  dbh       => $dbh,
  namespace => 'Sangoku::DB',
);
