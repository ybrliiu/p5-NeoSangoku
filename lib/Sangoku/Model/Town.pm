package Sangoku::Model::Town {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB';

  use Sangoku::Util qw/load_config/;

  use constant TABLE_NAME => 'town';

  after 'init' => sub {
    my ($class) = @_;

    my $init_data = load_config('etc/config/data/init_town.conf')->{'init_town'};
    $class->db->bulk_insert(TABLE_NAME, [values %$init_data]);
  };

  __PACKAGE__->meta->make_immutable();
}

1;
