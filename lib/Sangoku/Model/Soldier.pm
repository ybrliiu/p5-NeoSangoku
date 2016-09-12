package Sangoku::Model::Soldier {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::Config';

  use constant FILE => 'soldier';

  __PACKAGE__->meta->make_immutable();
}

1;
