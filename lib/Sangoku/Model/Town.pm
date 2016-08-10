package Sangoku::Model::Town {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB';

  use Sangoku::Util qw/load_config/;

  use constant TABLE_NAME => 'town';

  after 'init' => sub {
    my ($class) = @_;

    my $init_data = load_config('etc/config/data/init_town.conf')->{'init_town'};
    
    for my $town (values %$init_data) {
      $class->db->do_insert(TABLE_NAME() => $town);
    }
  };

  sub get {
    my ($class, $name) = @_;
    $class->db->single(TABLE_NAME() => {name => $name});
  }

  __PACKAGE__->meta->make_immutable();
}

1;
