package Sangoku::Model::Unit::Letter {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB';

  use Sangoku::Util qw/validate_values datetime/;
  use Sangoku::Model::Player::Letter;

  use constant TABLE_NAME => 'unit_letter';

  has 'id' => (is => 'ro', isa => 'Str', required => 1);

  sub get {
    my ($self) = @_;
    my @columns = $self->db->search(TABLE_NAME, {unit_id => $self->id}, {order_by => 'id DESC'});
    return \@columns;
  }

  sub add {
    my ($self, $args) = @_;
    validate_values($args => [qw/sender message/]);

    my %letter_data = (
      sender_name         => $args->{sender}->name,
      sender_icon         => $args->{sender}->icon,
      sender_town_name    => $args->{sender}->town_name,
      sender_country_name => $args->{sender}->country_name,
      receiver_name       => $self->id,
      message             => $args->{message},
      time                => datetime(),
    );

    $self->db->do_insert(TABLE_NAME, {unit_id => $self->id, %letter_data});
    Sangoku::Model::Player::Letter->new(id => $args->{sender}->id)->add_sended(\%letter_data);
  }

  __PACKAGE__->meta->make_immutable();
}

1;
