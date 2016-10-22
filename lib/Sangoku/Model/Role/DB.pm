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
      my $config = load_config('db.conf');
      $db = Sangoku::DB->new(%$config);
    }
  }
  
  sub get_all {
    my ($class) = @_;
    my @rows = $class->db->search($class->TABLE_NAME, {});
    return \@rows;
  }

  sub get_all_to_hash {
    my ($class) = @_;
    my $primary_key = $class->primary_key;
    my %rows = map { $_->$primary_key => $_ } @{ $class->get_all() };
    return \%rows;
  }

  sub count_all {
    my ($class) = @_;
    return $class->db->count($class->TABLE_NAME, '*');
  }

  sub delete_all {
    my ($class) = @_;
    $class->db->delete($class->TABLE_NAME, {});
  }

  sub primary_key {
    my ($class) = @_;
    state $primary_keys = {};
    return exists $primary_keys->{$class}
      ? $primary_keys->{$class}
      : ( $primary_keys->{$class} = $class->db->schema->get_table($class->TABLE_NAME)->primary_keys->[0] );
  }

  sub get {
    my ($class, $primary_value) = @_;
    return $class->db->single($class->TABLE_NAME, {$class->primary_key => $primary_value});
  }

  sub delete {
    my ($class, $primary_value) = @_;
    return $class->db->delete($class->TABLE_NAME, {$class->primary_key => $primary_value});
  }

  sub search {
    my ($class, $name, $value) = @_;
    my @rows = $class->db->search($class->TABLE_NAME, {$name => $value});
    return \@rows;
  }

  sub to_hash {
    my ($class, $lists) = @_;
    my $primary_key = $class->primary_key;
    my %rows = map { $_->$primary_key => $_ } @$lists;
    return \%rows;
  }

}

1;
