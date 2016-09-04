package Sangoku::Model::Country::ConferenceReply {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB';

  use Sangoku::Util qw/validate_values datetime/;

  use constant TABLE_NAME => 'country_conference_reply';

  has 'name'      => (is => 'ro', isa => 'Str', required => 1);
  has 'thread_id' => (is => 'ro', isa => 'Int', required => 1);

  sub get {
    my ($self) = @_;
    my @result = $self->db->search(TABLE_NAME, {
      country_name => $self->name,
      thread_id    => $self->thread_id,
    });
    return \@result;
  }

  sub add {
    my ($self, $args) = @_;
    validate_values($args => [qw/sender message/]);

    $self->db->do_insert(TABLE_NAME, {
      country_name => $self->name,
      thread_id    => $self->thread_id,
      name         => $args->{sender}->name,
      icon         => $args->{sender}->icon,
      message      => $args->{message},
      time         => datetime(),
    });
  }

  sub delete {
    my ($self, $id) = @_;

    if (ref $self) {
      $self->db->delete(TABLE_NAME, {
        country_name => $self->name,
        thread_id    => $self->thread_id,
      });
    } else {
      $self->db->delete(TABLE_NAME, {id => $id});
    }

  }

  __PACKAGE__->meta->make_immutable();
}

1;
