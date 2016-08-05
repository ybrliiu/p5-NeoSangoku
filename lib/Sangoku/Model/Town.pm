package Sangoku::Model::Town {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB';

  use Sangoku::Util qw/project_root_dir/;
  use Config::PL;

  use constant TABLE_NAME => 'town';

  sub init {
    my ($class) = @_;

    $class->delete_all();

    my $path = project_root_dir() . 'etc/config/data/init_town.conf';
    my $init_data = config_do($path)->{'init_town'};
    
    for my $town (values %$init_data) {
      $class->db->do_insert(TABLE_NAME() => $town);
    }
  }

  sub get {
    my ($class, $name) = @_;
    $class->db->single(TABLE_NAME() => {name => $name});
  }

  __PACKAGE__->meta->make_immutable();
}

1;
