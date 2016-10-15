package Sangoku::API::Command::Insert {

  use Mouse;
  use Sangoku;
  use Carp qw/croak/;

  has 'name' => (is => 'ro', isa => 'Str', default => '空白を入れる');

  with 'Sangoku::API::Command::Role::ChooseOption';

  sub _build_options {
    my ($self) = @_;
    return ['insert_number'];
  }

  # method name is input but this module is insert command.
  sub input {
    my ($self, $args) = @_;
    validate_values($args => [qw/player_id numbers/, @{ $self->options }]);
    my $model = $self->model('Player::Command')->new(id => $args->{player_id});
    $model->insert($args->{numbers}, $args->{insert_number});
  }

  __PACKAGE__->meta->make_immutable();
}

1;
