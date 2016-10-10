package Sangoku::DB::Row::Country {

  use Sangoku;
  use parent 'Sangoku::DB::Row';

  use Sangoku::Util qw/load_config/;
  use Sangoku::Model::Country::Position;
  use Sangoku::Model::Player;
  use Sangoku::Model::Town;

  use constant {
    CONSTANTS => {
      NAME_LEN_MIN => 1,
      NAME_LEN_MAX => 16,
    },
    COLOR => load_config('etc/config/color.conf')->{countrycolor},
  };

  sub position {
    my ($self, $hash) = @_;
    return $hash->{$self->name} if defined $hash;
    return Sangoku::Model::Country::Position->get($self->name);
  }

  sub members {
    my ($self, $players_hash) = @_;
    my $members = defined($players_hash)
      ? [sort { $b->class <=> $a->class } grep { $_->country_name eq $self->name } values %$players_hash]
      : Sangoku::Model::Player->search(country_name => $self->name);
    return $members;
  }

  sub towns {
    my ($self, $towns) = @_;
    my $country_towns = defined($towns)
      ? [grep { $_->country_name eq $self->name } @$towns]
      : Sangoku::Model::Town->search(country_name => $self->name);
    return $country_towns;
  }

  sub letter {
    my ($self) = @_;
    return $self->model('Country::Letter')->new(name => $self->name);
  }

}

1;
