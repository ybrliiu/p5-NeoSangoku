package Sangoku::Model::Role::DB {

  use Sangoku;
  use Mouse::Role;
  requires qw/TABLE_NAME/;

  use Sangoku::Util qw/load_config/;
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
      my $config = load_config('etc/config/db.conf');
      $db = Sangoku::DB->new(%$config);
    }
  }
  
  sub get_all {
    my ($class) = @_;
    my @rows = $class->db->search($class->TABLE_NAME, {});
    return \@rows;
  }

  sub delete_all {
    my ($class) = @_;
    $class->db->delete($class->TABLE_NAME => {});
  }

  sub init {
    my ($class) = @_;
    $class->delete_all();
  }

  # __PACKAGE__->generate_methods;
  sub generate_methods {
    my ($class) = @_;

    my $primary_keys = $class->db->schema->get_table($class->TABLE_NAME)->primary_keys;
    my $table_name = $class->TABLE_NAME;

    my $meta = $class->meta;

    $meta->add_method(get => sub {
      my ($class, $primary_key) = @_;
      return $class->db->single($table_name, {$primary_keys->[0] => $primary_key});
    });

    $meta->add_method(delete => sub {
      my ($class, $primary_key) = @_;
      return $class->db->delete($table_name, {$primary_keys->[0] => $primary_key});
    });
  }

}

1;
