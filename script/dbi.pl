use FindBin;
use lib "$FindBin::Bin/../lib";
use Sangoku;

use DBI;
use Sangoku::Util qw/load_config/;

my $config = load_config('db.conf');
my $dbh = DBI->connect(@{ $config->{connect_info} });

my $sth = $dbh->prepare("
  SELECT id from player_letter 
    WHERE player_id = ?
    ORDER BY id DESC
");
$sth->execute('monokuma');
my $last_id = $sth->fetch->[0];
say $last_id;
