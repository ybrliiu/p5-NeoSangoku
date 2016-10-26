package Sangoku::Model::Country {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB';

  use Sangoku::Util qw/load_child_module validate_values/;
  load_child_module(__PACKAGE__);

  use constant {
    TABLE_NAME   => 'country',
    NEUTRAL_DATA => {
      name  => '無所属',
      color => 'gray',
    },
  };

  sub init {
    my ($class) = @_;
    $class->create(NEUTRAL_DATA);
  }

  sub create {
    my ($class, $args) = @_;
    validate_values($args => [qw/name color/]);
    $class->db->do_insert(TABLE_NAME, $args);
  }

  __PACKAGE__->meta->make_immutable();
}

1;
