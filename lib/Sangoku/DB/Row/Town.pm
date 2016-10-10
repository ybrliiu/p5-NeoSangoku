package Sangoku::DB::Row::Town {

  use Sangoku;
  use parent 'Teng::Row';

  use Sangoku::Model::Town::Guards;
  use Sangoku::Model::Country;
  use Sangoku::Model::Site;

  use constant ICONS_DIR_PATH => '/images/map_icon/';

  sub country {
    my ($self, $countreis_hash) = @_;
    return defined $countreis_hash
      ? $countreis_hash->{$self->country_name}
      : Sangoku::Model::Country->get($self->country_name);
  }

  sub can_establish_nation {
    my ($self) = @_;
    my $neutral_name = Sangoku::Model::Country->NEUTRAL_DATA->{name};
    return $self->country_name eq $neutral_name;
  }

  sub guards {
    my ($self, $guards_hash) = @_;
    return defined($guards_hash)
      ? $guards_hash->{$self->name}
      : Sangoku::Model::Town::Guards->new(name => $self->name)->get();
  }

  sub icon_path {
    my ($self) = @_;
    return ICONS_DIR_PATH . $self->lank() . '.png';
  }

  sub lank {
    my ($self) = @_;
    my $lank = 1;
    for(qw/500 1000 4000 8000/){
      if ($self->farmer      >= $_ * 20
        && $self->farm       >= $_
        && $self->business   >= $_
        && $self->technology >= $_
        && $self->wall       >= $_
        && $self->wall_power  >= $_
      ) {
        $lank++;
      }
    }
    return $lank;
  }
 
  sub wall_power_max {
    my ($self, $year) = @_;
    $year //= Sangoku::Model::Site->get->game_year;

    my $wall_power = do {
      my $wall_power = $year * 125;
        $wall_power < 1000 ? 1000
      : $wall_power > 9999 ? 9999
      : $wall_power;
    };
    return $wall_power;
  }

}

1;
