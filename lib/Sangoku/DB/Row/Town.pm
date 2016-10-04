package Sangoku::DB::Row::Town {

  use Sangoku;
  use parent 'Teng::Row';

  use Sangoku::Model::Country;

  sub country {
    my ($self, $country) = @_;
    Sangoku::Model::Country->get($self->country_name);
  }

  sub can_establish_nation {
    my ($self) = @_;
    my $neutral_name = Sangoku::Model::Country->NEUTRAL_DATA->{name};
    return $self->country_name eq $neutral_name;
  }

}

1;
