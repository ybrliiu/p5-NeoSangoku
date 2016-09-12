package Sangoku::Model::Book {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::Config';

  use constant FILE => 'book';

  __PACKAGE__->meta->make_immutable();
}

1;
