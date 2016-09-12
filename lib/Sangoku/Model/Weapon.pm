package Sangoku::Model::Weapon {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::Config';

  use constant FILE => 'weapon';

  __PACKAGE__->meta->make_immutable();
}

1;
