package Sangoku::API::Player::CommandLog {

  use Sangoku;
  use Mouse;
  with "Sangoku::API::Role::Record::$_" for qw/Player Log/;

  use overload (
    q{""}    => 'string',
    fallback => 1,
  );

  use constant DIR_PATH => 'command_log/';

  __PACKAGE__->meta->make_immutable();
}

1;
