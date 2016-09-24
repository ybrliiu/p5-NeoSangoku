package Sangoku::Service::Role::Base {

  use Sangoku;
  use Mouse::Role;
  
  use Sangoku::DB;
  use Sangoku::Util qw/load/;
  use Sangoku::Model::Role::DB;

  sub txn {
    my ($class) = @_;
    return Sangoku::Model::Role::DB->db->txn_scope();
  }

  sub model {
    my ($class, $name) = @_;

    state $module_names = {};
    return $module_names->{$name} if exists $module_names->{$name};

    my $pkg = "Sangoku::Model::$name";
    load $pkg;
    $module_names->{$name} = $pkg;
  }

}

1;
