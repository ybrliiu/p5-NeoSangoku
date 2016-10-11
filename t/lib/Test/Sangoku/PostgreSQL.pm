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

    # schema 流し込み
    {
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

}

1;


__END__

=encoding utf-8

=head1 名前
  
  Test::Sangoku::PostgreSQL - sangoku専用のPostgreSQLを使ったテストをするためのモジュール

=head1 使用法

  # harriet と一緒に使うことを想定(see also harriet)

  # t/harriet/postgresql.pl に以下のように記述しているとして
  $ENV{TEST_POSTGRESQL} ||= do {
    require Test::PostgreSQL;
    my $pgsql = Test::PostgreSQL->new() or die $Test::PostgreSQL::errstr;
    $ENV{TEST_POSTGRESQL_USER} = 'postgres';
    $HARRIET_GUARDS::POSTGRESQL = $pgsql;
    $pgsql->dsn;
  }

  # model側で
  sub db {
    my ($class) = @_;
    
    state $db;
    return $db if defined $db;

    # DB使うテストの時に切り替え
    if ($ENV{TEST_POSTGRESQL}) {
      my ($dsn, $user) = ($ENV{TEST_POSTGRESQL}, $ENV{TEST_POSTGRESQL_USER});
      $db = Sangoku::DB->new(connect_info => [$dsn, $user]);
    } else {
      my $config = load_config('etc/config/db.conf');
      $db = Sangoku::DB->new(%$config);
    }
  }

  # テスト側
  # 事前にt/harriet/postgresql.plを読み込んでおく
  # .proverc に -PHarriet=t/harriet/ と記述するなど
  Test::Sangoku::PostgreSQL;

  # 立ち上げたpostgresqlサーバのdbiインスタンスを生成し、指定されたスキーマファイルを流し込む(default: etc/documents/sangoku_schema.sql)
  my $psql = Test::Sangoku::PostgreSQL->new();
  # or
  my $psql = Test::Sangoku::PostgreSQL->new(schema => 'sangoku.sql');

  # テストするために必要な環境を構築する
  {
    load $model;
    $model->init;
  }

  # テスト終了時にDESTROYが呼ばれて全てのテーブルが削除される

=cut
