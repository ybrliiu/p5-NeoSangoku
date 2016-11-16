package Sangoku::Model::Player::ReadLetter {

  use Mouse;
  use Sangoku;
  with 'Sangoku::Model::Role::RecordMultipleFile::Single';

  use Sangoku::API::Player::ReadLetter;

  use constant CLASS => 'Sangoku::API::Player::ReadLetter';

  __PACKAGE__->meta->make_immutable();
}

1;
