package Sangoku::Model::Player::Profile {

  use Mouse;
  use Sangoku;
  with 'Sangoku::Model::Role::RecordMultiple::Single';

  use Sangoku::API::Player::Profile;

  use constant CLASS => 'Sangoku::API::Player::Profile';

  around 'init' => sub {
    my ($orig, $self, $message) = @_;
    $self->$orig(sub {
      my ($self, $profile) = @_;
      $profile->message($message) if $message;
    });
  };

  __PACKAGE__->meta->make_immutable();
}

1;
