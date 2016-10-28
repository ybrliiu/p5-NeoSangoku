package Sangoku::DB::Row::Country {

  use Sangoku;
  use parent 'Sangoku::DB::Row';

  use Sangoku::Util qw/load_config get_all_constants/;

  use constant {
    NAME_LEN_MIN => 1,
    NAME_LEN_MAX => 16,
    COLOR        => load_config('color.conf')->{countrycolor},
  };

  sub position {
    my ($self, $hash) = @_;
    return $hash->{$self->name} if defined $hash;
    return $self->model('Country::Position')->get($self->name);
  }

  sub players {
    my ($self, $players_hash) = @_;
    my $players = ref $players_hash eq 'HASH'
      ? [sort { $b->class <=> $a->class } grep { $_->country_name eq $self->name } values %$players_hash]
      : $self->model('Player')->search(country_name => $self->name);
    return $players;
  }

  sub towns {
    my ($self, $towns) = @_;
    my $country_towns = ref $towns eq 'ARRAY'
      ? [grep { $_->country_name eq $self->name } @$towns]
      : $self->model('Town')->search(country_name => $self->name);
    return $country_towns;
  }

  sub letter {
    my ($self, $limit) = @_;
    my $model = $self->model('Country::Letter')->new(name => $self->name);
    return $model->get($limit);
  }

}

1;
