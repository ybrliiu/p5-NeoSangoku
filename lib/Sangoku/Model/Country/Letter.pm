package Sangoku::Model::Country::Letter {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB::Letter';

  use constant TABLE_NAME => 'country_letter';

  has 'name' => (is => 'ro', isa => 'Str', required => 1);

  __PACKAGE__->meta->make_immutable();
}

1;
