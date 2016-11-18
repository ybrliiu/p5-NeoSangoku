package Sangoku::API::Player::ReadLetter {

  use Mouse;
  use Sangoku;
  with 'Sangoku::API::Role::Record::Player';

  use constant {
    DIR_PATH => 'read_letter/',
    MAX      => 1,
  };

  has [qw/player invite unit country town/] => (is => 'rw', isa => 'Int', default => 0);

  __PACKAGE__->meta->make_immutable();
}

1;

