package Sangoku::Model::Country::ConferenceThread {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB::Thread';

  use Sangoku::Util qw/validate_values datetime/;

  use constant TABLE_NAME => 'country_conference_thread';

  has 'name' => (is => 'ro', isa => 'Str', required => 1);

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

  __PACKAGE__->meta->make_immutable();
}

1;
