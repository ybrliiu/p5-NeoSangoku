package Sangoku::API::Player::Profile {

  use Mouse;
  use Sangoku;
  with 'Sangoku::API::Role::Record::Player';

  use constant {
    DIR_PATH => 'profile/',
    MAX      => 1,
    PROFILE_LEN_MAX => 1000,
  };

  has 'message' => (is => 'rw', default => '');

  sub validate_message {
    my ($class, $validator) = @_;
    $validator->check(profile => [[LENGTH => (0, PROFILE_LEN_MAX)]]);
  }

  __PACKAGE__->meta->make_immutable();
}

1;
