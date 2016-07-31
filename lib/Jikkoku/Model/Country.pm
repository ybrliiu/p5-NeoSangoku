package Jikkoku::Model::Country {

  use Jikkoku;
  use Mouse;
  with 'Jikkoku::Model::Role::DB';

  use Jikkoku::Util qw/project_root_dir/;
  use Config::PL;

  use constant TABLE_NAME => 'country';

  sub init {
    my ($class) = @_;
    $class->delete_all();
    $class->db->do_insert(TABLE_NAME() => { name => '無所属', color => 'gray' });
  }

  sub get {
    my ($class, $name) = @_;
    $class->db->single(TABLE_NAME() => {name => $name});
  }

}

1;
