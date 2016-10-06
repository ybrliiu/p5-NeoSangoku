package Sangoku::DB::Row::Town {

  use Sangoku;
  use parent 'Teng::Row';

  use Sangoku::Model::Country;

  use constant ICONS_DIR_PATH => '/images/map_icon/';

  sub icon_path {
    my ($self) = @_;
    return ICONS_DIR_PATH . '1.png';
  }

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
