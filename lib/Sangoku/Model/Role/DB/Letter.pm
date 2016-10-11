package Sangoku::Model::Role::DB::Letter {

  use Sangoku;
  use Mouse::Role;
  with 'Sangoku::Model::Role::DB';

  use Sangoku::Util qw/validate_values datetime/;

  has 'where' => (is => 'rw', isa => 'HashRef', lazy => 1, builder => '_build_where');

  sub _build_where {
    my ($self) = @_;

    my $meta = $self->meta;

    my $attribute_name = do {
      # Unit::Letter, Player::Letter, Player::Invite
      if ( $meta->has_attribute('id') ) {
        'id';
      }
      # Town::Letter, Country::Letter
      elsif ( $meta->has_attribute('name') ) {
        'name';
      } else {
        die 'id もしくは name attributeが見つかりませんでした。';
      }
    };

    my $parent_table = lc( (split /::/, ref $self)[2] );

    return {"${parent_table}_${attribute_name}" => $self->$attribute_name};
  }

  sub get {
    my ($self) = @_;
    my @columns = $self->db->search($self->TABLE_NAME, $self->where, {order_by => 'id DESC'});
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
      receiver_name       => $self->name,
      message             => $args->{message},
      time                => datetime(),
    );

    $self->db->do_insert($self->TABLE_NAME, {%{ $self->where }, %letter_data});
    require Sangoku::Model::Player::Letter;
    Sangoku::Model::Player::Letter->new(id => $args->{sender}->id)->add_sended(\%letter_data);

    return \%letter_data;
  }

}

1;
