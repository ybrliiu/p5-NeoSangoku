package Sangoku::DB::Row::Town {

  use Mouse;
  use Sangoku;
  extends 'Sangoku::DB::Row';

  use constant {
    ICONS_DIR_PATH  => '/images/map_icon/',
    WALL_POWER_COEF => 125,
    WALL_POWER_MIN  => 1000,
    WALL_POWER_MAX  => 9999,
  };

  __PACKAGE__->_generate_letter_method();
  
  sub country {
    my ($self, $countreis_hash) = @_;
    return $self->{country} if exists $self->{country};
    $self->{country} = ref $countreis_hash eq 'HASH'
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
    return $self->{guards} if exists $self->{guards};
    $self->{guards} = ref $guards_hash eq 'HASH'
      ? $guards_hash->{$self->name}
      : $self->model('Town::Guards')->new(name => $self->name)->get();
  }

  sub icon_path {
    my ($self) = @_;
    return ICONS_DIR_PATH . $self->lank . '.png';
  }

  sub lank {
    my ($self) = @_;
    my $lank = 1;
    for (qw/500 1000 4000 8000/) {
      if ($self->farmer      >= $_ * 20
        && $self->farm       >= $_
        && $self->business   >= $_
        && $self->technology >= $_
        && $self->wall       >= $_
        && $self->wall_power >= $_
      ) {
        $lank++;
      }
    }
    return $lank;
  }
 
  sub wall_power_max {
    my ($self, $year) = @_;
    $year //= $self->model('Site')->get->game_year;

    my $wall_power = do {
      my $wall_power = $year * WALL_POWER_COEF;
        $wall_power < WALL_POWER_MIN ? WALL_POWER_MIN 
      : $wall_power > WALL_POWER_MAX ? WALL_POWER_MAX
      : $wall_power;
    };
    return $wall_power;
  }

  __PACKAGE__->meta->make_immutable();
}

1;
