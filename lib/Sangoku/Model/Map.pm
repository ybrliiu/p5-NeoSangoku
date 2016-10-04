package Sangoku::Model::Map {

  use Mouse;
  use Sangoku;
  
  use Sangoku::Model::Town;
  use Sangoku::Model::Country;
  
  my %Country_color = ();

  sub get {
    my ($class) = @_;

    $class->_cache_country_color() unless %Country_color;

    my $towns = Sangoku::Model::Town->get_all();
    my $map_data = [];
    for my $i (0 .. 9) {
      for my $j (0 .. 9) {
        for my $town (@$towns) {
          if ($town->y == $i && $town->x == $j) {
            $map_data->[$i][$j] = $town;
            $town->country_color($Country_color{$town->country_name});
          }
        }
      }
    }

    return $map_data;
  }

  sub _cache_country_color {
    my ($class) = @_;
    my $countries = Sangoku::Model::Country->get_all();
    %Country_color = map { $_->name => $_->color } @$countries;
  }

}

1;
