package Sangoku::Model::Player::Letter {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB::Letter';

  use Sangoku::Util qw/validate_values datetime/;

  use constant TABLE_NAME => 'player_letter';

  has 'id' => (is => 'ro', isa => 'Str', required => 1);

  sub get_without_same_letter {
    my ($self, $player, $num) = @_;
    $num //= 'ALL';

    my @columns = $self->db->search_by_sql(
      qq{SELECT * FROM @{[ TABLE_NAME() ]}
        WHERE player_id = ?
        AND receiver_name <> ?
        AND receiver_name <> ?
        @{[ $player->is_belong_unit ? "AND receiver_name <> ?" : '' ]}
        ORDER BY id DESC
        LIMIT $num},
      [
        $player->id,
        $player->town_name,
        $player->country_name,
        $player->is_belong_unit ? $player->unit->name : (),
      ],
      TABLE_NAME,
    );
    return \@columns;
  }

  sub add {
    my ($self, $args) = @_;
    validate_values($args => [qw/sender receiver message/]);

    my %letter_data = (
      sender_name         => $args->{sender}->name,
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

    return \%letter_data;
  }

  # 国宛などで自分が送った手紙を自分宛にも保存するためのメソッド
  sub add_sended {
    my ($self, $args) = @_;
    validate_values($args => [qw/sender_name sender_icon 
      sender_town_name sender_country_name receiver_name message time/]);

    $args->{player_id} = $self->id;
    $self->db->do_insert(TABLE_NAME, $args);
  }

  __PACKAGE__->meta->make_immutable();
}

1;
