package Sangoku::Model::Unit::Letter {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB::Letter';

  use constant TABLE_NAME => 'unit_letter';

  has [qw/id name/] => (is => 'ro', isa => 'Str', required => 1);

  __PACKAGE__->generate_method();

  __PACKAGE__->meta->make_immutable();
}

1;
