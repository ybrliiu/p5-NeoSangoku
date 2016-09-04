package Sangoku::Model::Country::ConferenceThread {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB';

  use Sangoku::Util qw/validate_values datetime/;

  use constant TABLE_NAME => 'country_conference_thread';

  has 'name' => (is => 'ro', isa => 'Str', required => 1);

  sub get {
    my ($self, $limit, $offset) = @_;

    my @columns = $self->db->search(
      TABLE_NAME,
      {country_name => $self->name},
      {
        order_by => 'id DESC',
        defined $limit ? (limit => $limit) : (),
        defined $offset ? (offset => $offset) : (),
      },
    );
    return \@columns;
  }

  sub add {
    my ($self, $args) = @_;
    validate_values($args => [qw/sender title message/]);

    $self->db->do_insert(TABLE_NAME, {
      country_name => $self->name,
      title        => $args->{title},
      name         => $args->{sender}->name,
      icon         => $args->{sender}->icon,
      message      => $args->{message},
      time         => datetime(),
    });
  }

  sub delete {
    my ($self, $id) = @_;
    $self->db->delete(TABLE_NAME, {id => $id});
  }

  __PACKAGE__->meta->make_immutable();
}

1;
