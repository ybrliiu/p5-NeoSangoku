package Sangoku::API::Player::Profile {

  use Mouse;
  use Sangoku;
  with 'Sangoku::API::Role::Record::Player';

  use constant {
    DIR_PATH => 'profile/',
    MAX      => 1,
  };

  has 'message' => (is => 'rw', default => '');

  __PACKAGE__->meta->make_immutable();
}

1;
