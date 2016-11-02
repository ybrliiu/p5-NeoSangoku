package Sangoku::Service::Role::Base {

  use Sangoku;
  use Mouse::Role;
  with qw/Sangoku::Role::Config Sangoku::Role::Loader/;
  
  use Sangoku::DB;
  use Sangoku::Model::Role::DB;
  use Sangoku::Validator;

  Sangoku::Validator->load_constraints(qw/Number/);
  __PACKAGE__->config('template.conf');

  sub txn {
    my ($class) = @_;
    return Sangoku::Model::Role::DB->db->txn_scope();
  }

  sub validator {
    my ($class, $args) = @_;
    my $validator = Sangoku::Validator->new($args);
    $validator->load_default_messages();
    return $validator;
  }

}

1;
