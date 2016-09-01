package Sangoku::Model::Player::Invite {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB';

  use Sangoku::Util qw/validate_values datetime/;

  use constant TABLE_NAME => 'player_invite';

  has 'id' => (is => 'ro', isa => 'Str', required => 1);

  sub get {
    my ($self) = @_;
    my @columns = $self->db->search(TABLE_NAME, {player_id => $self->id}, {order_by => 'id DESC'});
    return \@columns;
  }

  sub add {
    my ($self, $args) = @_;
    validate_values($args => [qw/sender receiver message/]);

    my %letter_data = (
      sender_name         => $args->{sender}->name,
      sender_id           => $args->{sender}->id,
      sender_icon         => $args->{sender}->icon,
      sender_town_name    => $args->{sender}->town_name,
      sender_country_name => $args->{sender}->country_name,
      receiver_name       => $args->{receiver}->name,
      message             => $args->{message},
      time                => datetime(),
    );

    $self->db->bulk_insert(TABLE_NAME, [
      {player_id => $self->id, %letter_data},
      {player_id => $args->{receiver}->id, %letter_data},
    ]);
  }

  __PACKAGE__->meta->make_immutable();
}

1;

