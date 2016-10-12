package Sangoku::API::Command::Delete {

  use Mouse;
  use Sangoku;
  use Carp qw/croak/;

  has 'name' => (is => 'ro', isa => 'Str', default => 'コマンドを削除');

  with 'Sangoku::API::Command::Base';

  # method name input but this module delete command.
  sub input {
    my ($self, $args) = @_;
    validate_values($args => [qw/player_id numbers/]);
    my $model = $self->model('Player::Command')->new(id => $args->{player_id});
    $model->delete($args->{numbers});
  }

  sub execute { croak 'Insert Command cant execute!!' }

  __PACKAGE__->meta->make_immutable();
}

1;
