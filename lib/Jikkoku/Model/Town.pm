package Jikkoku::Model::Town {

  use Jikkoku;
  use Mouse;
  with 'Jikkoku::Model::Role::DB';

  use Jikkoku::Util qw/project_root_dir/;
  use Config::PL;

  use constant TABLE_NAME => 'town';

  sub init {
    my ($class) = @_;

    $class->delete_all();

    my $path = project_root_dir() . 'etc/config/data/init_town.conf';
    my $init_data = config_do($path);
    
    for my $town (values %{ $init_data->{init_town} }) {
      $class->db->fast_insert(TABLE_NAME() => $town);
    }
  }

}

1;
