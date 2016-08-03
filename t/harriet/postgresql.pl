$ENV{TEST_POSTGRESQL} ||= do {
  require Test::PostgreSQL;
  my $pgsql = Test::PostgreSQL->new() or die $Test::PostgreSQL::errstr;
  $HARRIET_GUARDS::POSTGRESQL = $pgsql;
  $pgsql->dsn;
};
