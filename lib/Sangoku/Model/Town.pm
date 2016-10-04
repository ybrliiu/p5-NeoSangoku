package Sangoku::Model::Town {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB';

  use Sangoku::Util qw/load_config/;

  use constant TABLE_NAME => 'town';

  sub init {
    my ($class) = @_;
    my $init_data = load_config('etc/config/data/init_town.conf')->{'init_town'};
    $class->db->bulk_insert(TABLE_NAME, $init_data);
  }

  sub get_all_for_map {
    my ($class) = @_;

    my $towns = $class->get_all();
    my $map_data = [];
    for my $i (0 .. 9) {
      for my $j (0 .. 9) {
        for my $town (@$towns) {
          if ($town->y == $i && $town->x == $j) {
            $map_data->[$i][$j] = $town;
          }
        }
      }
    }

    return $map_data;
  }

  __PACKAGE__->meta->make_immutable();
}

1;
