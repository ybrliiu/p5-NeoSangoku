package Sangoku::Service::Role::Base {

  use Sangoku;
  use Mouse::Role;
  
  use Sangoku::DB;
  # model, row, api is method
  use Sangoku::Util qw/load config model row api/;
  config('template.conf');
  use Sangoku::Model::Role::DB;
  use Sangoku::Validator;
  Sangoku::Validator->load_constraints(qw/Number/);

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
