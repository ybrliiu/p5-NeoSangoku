package Sangoku::Model::Country {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB::Parent';

  use Sangoku::Util qw/load_child_module validate_values/;
  load_child_module(__PACKAGE__);

  use constant {
    TABLE_NAME   => 'country',
    NEUTRAL_DATA => {
      name    => '無所属',
      color   => 'gray',
      king_id => '',
    },
  };

  after 'init' => sub {
    my ($class) = @_;
    $class->regist({name => '無所属', color => 'gray', king_id => ''});
  };

  sub get {
    my ($class, $name) = @_;
    $class->db->single(TABLE_NAME, {name => $name});
  }

  sub delete {
    my ($class, $name) = @_;
    $class->db->delete(TABLE_NAME, {name => $name});
  }

  sub create {
    my ($class, $args) = @_;
    validate_values($args => [qw/name color/]);
    $class->db->do_insert(TABLE_NAME, $args);
  }

  sub regist {
    my ($class, $args) = @_;
    validate_values($args => [qw/name color king_id/]);

    $class->create({
      name  => $args->{name},
      color => $args->{color},
    }); 

    Sangoku::Model::Country::Position->create({
      name    => $args->{name},
      king_id => $args->{king_id},
    });
  }

  sub erase {
    my ($class, $name) = @_;
    $class->delete($name);
  }

  __PACKAGE__->meta->make_immutable();
}

1;
