package Sangoku::Model::Country::Letter {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB::Letter';

  use constant TABLE_NAME => 'country_letter';

  has 'name' => (is => 'ro', isa => 'Str', required => 1);

  sub add {
    my ($self, $args) = @_;
    validate_values($args => [qw/sender receiver_name message/]);

    my %letter_data = (
      sender_name         => $args->{sender}->name,
      sender_icon         => $args->{sender}->icon,
      sender_town_name    => $args->{sender}->town_name,
      sender_country_name => $args->{sender}->country_name,
      receiver_name       => $args->{receiver_name},
      message             => $args->{message},
      time                => datetime(),
    );

    my $letter = do {
      if ($self->name eq $args->{receiver_name}) {
        $self->db->insert(TABLE_NAME, {country_name => $self->name, %letter_data});
      }
      # 他国宛に送信する場合は自国にもログ残す
      else {
        $self->db->bulk_insert(TABLE_NAME, [
          {country_name => $args->{receiver_name}, %letter_data},
          {country_name => $self->name, %letter_data},
        ]);
        $self->get(1)->[0];
      }
    };

    $letter_data{letter_type} = $self->letter_type;
    Sangoku::Model::Player::Letter->new(id => $args->{sender}->id)->add_sended(\%letter_data);

    $letter_data{id} = $letter->id;
    return \%letter_data;
  }

  __PACKAGE__->meta->make_immutable();
}

1;
