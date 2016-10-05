package Sangoku::API::Player::Command {

  use Sangoku;
  use Mouse;
  with 'Sangoku::API::Role::Record::Player';

  use constant {
    DIR_PATH => 'command/',
    MAX      => 126,
  };

  has [qw/id detail/] => (is => 'ro', isa => 'Str', required => 1);
  has 'options'       => (is => 'ro', isa => 'HashRef');

  # $class->file_path() = 'etc/record/player/command/$id.dat'
  
  __PACKAGE__->meta->make_immutable();
}

1;
