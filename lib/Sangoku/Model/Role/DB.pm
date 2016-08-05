package Sangoku::Model::Role::DB {

  use Sangoku;
  use Mouse::Role;
  requires qw/TABLE_NAME get/;

  use Sangoku::Util qw/project_root_dir/;
  use Config::PL;
  use Sangoku::DB;

  sub db {
    my ($class) = @_;
    
    state $db;
    return $db if defined $db;

    # DB使うテストの時
    if ($ENV{TEST_POSTGRESQL}) {
      my ($dsn, $user) = ($ENV{TEST_POSTGRESQL}, $ENV{TEST_POSTGRESQL_USER});
      $db = Sangoku::DB->new(connect_info => [$dsn, $user]);
    } else {
      my $path = project_root_dir() . 'etc/config/db.conf';
      my $config = config_do($path);
      $db = Sangoku::DB->new(%$config);
    }
  }

  sub get_all {
    my ($class) = @_;
    my @rows = $class->db->search($class->TABLE_NAME => {});
    return \@rows;
  }

  sub delete_all {
    my ($class) = @_;
    $class->db->delete($class->TABLE_NAME => {});
  }

}

1;
