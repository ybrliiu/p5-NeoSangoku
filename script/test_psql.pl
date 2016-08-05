use Sangoku 'test';

use DBI;
use SQL::SplitStatement;
use Path::Tiny;
use Test::PostgreSQL;

my $pgsql = Test::PostgreSQL->new() || die 'pgsql fail.';
my $dbh = DBI->connect($pgsql->dsn) || die 'dbi fail.';
my $file = path('etc/documents', 'sangoku_schema.sql');
my $sql = $file->slurp();
my $splitter = SQL::SplitStatement->new(
  keep_terminator      => 1,
  keep_comments        => 0,
  keep_empty_statement => 0,
);
for ( $splitter->split($sql) ) {
  $dbh->do($_) || die $dbh->errstr;
}

$dbh->do(q{INSERT INTO country (name, color) VALUES ('無所属', 'gray');});
my $sth = $dbh->prepare('SELECT * FROM country');
$sth->execute;
while (my @row = $sth->fetchrow_array) {
  say "$_, " for @row;
}
$sth->finish;

