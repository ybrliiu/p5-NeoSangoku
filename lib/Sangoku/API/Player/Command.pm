package Sangoku::API::Player::Command {

  use Mouse;
  use Sangoku;
  with 'Sangoku::API::Role::Record::Player';

  use constant {
    DIR_PATH => 'command/',
    MAX      => 126,
  };

  has 'id'      => (is => 'ro', isa => 'Str', required => 1);
  has 'detail'  => (is => 'rw', isa => 'Str', required => 1);
  has 'options' => (is => 'ro', isa => 'HashRef');

  # $class->file_path() = 'etc/record/player/command/$id.dat'
  
  __PACKAGE__->meta->make_immutable();
}

1;
