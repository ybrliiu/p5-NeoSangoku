package Sangoku::DB::Row::Town {

  use Sangoku;
  use parent 'Sangoku::DB::Row';

  use constant ICONS_DIR_PATH => '/images/map_icon/';

  sub country {
    my ($self, $countreis_hash) = @_;
    return defined $countreis_hash
      ? $countreis_hash->{$self->country_name}
      : $self->model('Country')->get($self->country_name);
  }

  sub can_establish_nation {
    my ($self) = @_;
    my $neutral_name = $self->model('Country')->NEUTRAL_DATA->{name};
    return $self->country_name eq $neutral_name;
  }

  sub guards {
    my ($self, $guards_hash) = @_;
    return defined($guards_hash)
      ? $guards_hash->{$self->name}
      : $self->model('Town::Guards')->new(name => $self->name)->get();
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

  sub letter {
    my ($self) = @_;
    return $self->model('Town::Letter')->new(name => $self->name);
  }
 
  sub wall_power_max {
    my ($self, $year) = @_;
    $year //= $self->model('Site')->get->game_year;

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
