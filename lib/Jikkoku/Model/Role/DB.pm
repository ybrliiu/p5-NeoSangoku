package Jikkoku::Model::Role::DB {

  use Jikkoku;
  use Mouse::Role;
  requires qw/TABLE_NAME get/;

  use Jikkoku::Util qw/project_root_dir/;
  use Config::PL;
  use Jikkoku::DB;

  sub db {
    my ($class) = @_;
    
    state $db;
    return $db if defined $db;

    my $path = project_root_dir() . 'etc/config/db.conf';
    my $config = config_do($path);
    $db = Jikkoku::DB->new(%$config);
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
