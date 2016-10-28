package Sangoku::Model::Town {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB';

  use Sangoku::Util qw/load_config/;

  use constant TABLE_NAME => 'town';

  sub init {
    my ($class) = @_;
    my $init_data = load_config('data/init_town.conf')->{'init_town'};
    $class->db->bulk_insert(TABLE_NAME, $init_data);
  }

  sub get_all_for_map {
    my ($class, $towns) = @_;

    my $towns_hash = ref $towns eq 'ARRAY' ? $class->to_hash($towns)
      : ref $towns eq 'HASH' ? $towns : $class->get_all_to_hash;
    my $map_data = [];

    for my $i (0 .. 9) {
      for my $j (0 .. 9) {
        for (keys %$towns_hash) {
          my $town = $towns_hash->{$_};
          if ($town->y == $i && $town->x == $j) {
            $map_data->[$i][$j] = $town;
            delete $towns_hash->{$_};
          }
        }
      }
    }

    return $map_data;
  }

  __PACKAGE__->meta->make_immutable();
}

1;
