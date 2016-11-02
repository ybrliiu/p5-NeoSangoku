package Sangoku::DB::Row::Player::Soldier {

  use Mouse;
  use Sangoku;
  extends 'Sangoku::DB::Row';

  my %SOLDIER_DATA = %{ __PACKAGE__->model('Soldier')->to_hash() };

  sub attack_power {
    my ($self, $player) = @_;
    $self->{soldier_data} //= $SOLDIER_DATA{$self->name};
    return $self->{soldier_data}->{attack_power}->($player)
      + $player->force;
  }

  sub defense_power {
    my ($self, $player) = @_;
    $self->{soldier_data} //= $SOLDIER_DATA{$self->name};
    return $self->{soldier_data}->{defense_power}->($player)
      + int($self->training / 5);
  }

  __PACKAGE__->meta->make_immutable();
}

1;
