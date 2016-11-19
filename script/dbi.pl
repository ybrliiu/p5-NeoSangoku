use FindBin;
use lib "$FindBin::Bin/../lib";
use Sangoku;
binmode STDOUT, ':utf8';

use DBI;
use Sangoku::Util qw/load_config/;
use Data::Dumper;

my $config = load_config('db.conf');
my $dbh = DBI->connect(@{ $config->{connect_info} });

my $sth = $dbh->prepare("SELECT DISTINCT receiver_name FROM player_letter where player_id = 'monokuma' GROUP BY id limit 15;");
$sth->execute;

my $array_ref = $sth->fetchall_arrayref({receiver_name => 1});
say Dumper $array_ref;
my @transmission_history = map { $_->[0] } @$array_ref;
say $_ for @transmission_history;

=head
my $sth = $dbh->prepare("
  SELECT id from player_letter 
    WHERE player_id = ?
    ORDER BY id DESC
");
$sth->execute('monokuma');

my $last_id = $sth->fetch->[0];
say $last_id;
=cut
