package Sangoku::DB::Row::Player::Soldier {

  use Sangoku;
  use parent 'Sangoku::DB::Row';

  use Sangoku::Model::Soldier;
  use Data::Dumper;

  my %SOLDIER_DATA = %{ Sangoku::Model::Soldier->to_hash() };

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

}

1;
