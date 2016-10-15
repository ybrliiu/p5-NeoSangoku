package Sangoku::API::Command::Insert {

  use Mouse;
  use Sangoku;
  use Carp qw/croak/;

  has 'name'        => (is => 'ro', isa => 'Str', default => '空白を入れる');
  has 'select_page' => (is => 'ro', isa => 'Int', default => 1);
  has 'form_name'   => (is => 'ro', isa => 'ArrayRef', lazy => 1, builder => '_build_form_name');

  with 'Sangoku::API::Command::Base';

  sub _build_form_name {
    my ($self) = @_;
    return [qw/insert_number/];
  }

  # method name is input but this module is insert command.
  sub input {
    my ($self, $args) = @_;
    validate_values($args => [qw/player_id numbers insert_number/]);
    my $model = $self->model('Player::Command')->new(id => $args->{player_id});
    $model->insert($args->{numbers}, $args->{insert_number});
  }

  sub select {
    my ($self, $args) = @_;
    validate_values($args => [qw/player_id current_page numbers/]);

    $args->{current_page}++;
    return {
      command_id     => $self->id,
      numbers        => $args->{numbers},
      next_page      => $args->{current_page},
      next_page_name => "/player/mypage/command/@{[ lc $self->id ]}_$args->{current_page}",
      max_page       => $self->select_page,
      form_name      => $self->form_name->[$args->{current_page} - 1],
    };
  }

  __PACKAGE__->meta->make_immutable();
}

1;
