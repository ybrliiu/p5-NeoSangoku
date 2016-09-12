package Sangoku::Model::Skill {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::Config';

  use constant FILE => 'skill';

  __PACKAGE__->meta->make_immutable();
}

1;
