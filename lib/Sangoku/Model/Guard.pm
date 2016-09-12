package Sangoku::Model::Guard {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::Config';

  use constant FILE => 'guard';

  __PACKAGE__->meta->make_immutable();
}

1;
