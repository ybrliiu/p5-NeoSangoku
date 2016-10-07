package Sangoku::DB::Row::Country {

  use Sangoku;
  use parent 'Teng::Row';

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
      ? [sort { $a->class <=> $b->class } grep { $_->country_name eq $self->name } values %$players_hash]
      : Sangoku::Model::Player->search(country_name => $self->name);
    return $members;
  }

  sub towns {
    my ($self, $towns_hash) = @_;
    my $towns = defined($towns_hash)
      ? [sort { $a->name cmp $b->name } grep { $_->country_name eq $self->name } values %$towns_hash]
      : Sangoku::Model::Town->search(country_name => $self->name);
    return $towns;
  }

}

1;
