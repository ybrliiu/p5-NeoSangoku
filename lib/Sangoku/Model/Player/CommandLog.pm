package Sangoku::Model::Player::CommandLog {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::Record';

  __PACKAGE__->meta->make_immutable();
}

1;
