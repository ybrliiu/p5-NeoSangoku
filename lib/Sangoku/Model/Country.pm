package Sangoku::Model::Country {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB';

  use Sangoku::Util qw/project_root_dir/;
  use Config::PL;

  use constant TABLE_NAME => 'country';

  after 'init' => sub {
    my ($class) = @_;
    $class->db->do_insert(TABLE_NAME() => {name => '無所属', color => 'gray'});
  };

  sub get {
    my ($class, $name) = @_;
    $class->db->single(TABLE_NAME() => {name => $name});
  }

  __PACKAGE__->meta->make_immutable();
}

1;
