package Sangoku::Model::Town::Letter {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB::Letter';

  use constant TABLE_NAME => 'town_letter';

  has 'name' => (is => 'ro', isa => 'Str', required => 1);

  __PACKAGE__->prepare_method();

  __PACKAGE__->meta->make_immutable();
}

1;
