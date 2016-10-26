package Sangoku::Model::Unit::Letter {

  use Mouse;
  use Sangoku;
  with 'Sangoku::Model::Role::DB::Letter';

  use constant TABLE_NAME => 'unit_letter';

  has 'id' => (is => 'ro', isa => 'Str', required => 1);

  __PACKAGE__->meta->make_immutable();
}

1;
