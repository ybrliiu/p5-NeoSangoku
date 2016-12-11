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
    my ($class, $towns_hash) = @_;
    $towns_hash = $class->get_all_to_hash if ref $towns_hash ne 'HASH';

    my $map_data = [];
    for (keys %$towns_hash) {
      my $town = $towns_hash->{$_};
      $map_data->[ $town->y ][ $town->x ] = $town;
    }

    return $map_data;
  }

  __PACKAGE__->meta->make_immutable();
}

1;
