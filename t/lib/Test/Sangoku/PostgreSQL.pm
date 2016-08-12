package Test::Sangoku::PostgreSQL {

  use Sangoku;

# use Harriet; # テストの時に使うデーモン取扱
  use DBI;
  use SQL::SplitStatement;
  use Path::Tiny;
  use IO::Scalar;

# Harriet->new('t/harriet')->load_all();

  sub new {
    my ($class, %args) = @_;

    state $default = {schema => 'etc/documents/sangoku_schema.sql'};
    my $dbh  = DBI->connect($ENV{TEST_POSTGRESQL}, $ENV{TEST_POSTGRESQL_USER}) or die 'connect failed.';
    my $self = {
      %$default, %args,
      dbh => $dbh,
    };

    my $schema = path($self->{schema});
    my $sql    = $schema->slurp();

    my $splitter = SQL::SplitStatement->new(
      keep_terminator      => 1,
      keep_comments        => 0,
      keep_empty_statement => 0,
    );
    for ( $splitter->split($sql) ) {
      $self->{dbh}->do($_) || die $self->{dbh}->errstr;
    }

    return bless $self, $class;
  }

  sub DESTROY {
    my ($self) = @_;

    # delete all table
    {
      my $fh = IO::Scalar->new(\my $anon);
      local *STDERR = $fh;
      $self->{dbh}->do('drop schema public cascade;');
      $self->{dbh}->do('create schema public;');
    }
  }

  sub construct {
    my ($class) = @_;
    my $dbh = DBI->connect($ENV{TEST_POSTGRESQL}, $ENV{TEST_POSTGRESQL_USER}) or die 'connect failed';
    my $file = path('etc/documents/sangoku_schema.sql');
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
