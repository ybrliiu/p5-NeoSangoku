package Test::Jikkoku::PostgreSQL {

  use Jikkoku;

  use Harriet; # テストの時に使うデーモン取扱
  use DBI;
  use SQL::SplitStatement;
  use Path::Tiny;
  use IO::Scalar;

  # Harriet->new('t/harriet')->load_all();

  sub construct {
    my ($class) = @_;
    my $dbh = DBI->connect($ENV{TEST_POSTGRESQL}, $ENV{TEST_POSTGRESQL_USER}) or die 'connect failed';
    my $file = path('etc/documents', 'jikkoku_schema.sql');
    my $sql = $file->slurp();

    # delete all table
    {
      my $fh = IO::Scalar->new(\my $anon);
      local *STDERR = $fh;
      $dbh->do('drop schema public cascade;');
      $dbh->do('create schema public;');
    }

    my $splitter = SQL::SplitStatement->new(
      keep_terminator      => 1,
      keep_comments        => 0,
      keep_empty_statement => 0,
    );
    for ( $splitter->split($sql) ) {
      $dbh->do($_) || die $dbh->errstr;
    }
  }


}

1;
