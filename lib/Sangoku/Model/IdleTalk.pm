package Sangoku::Model::IdleTalk {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB';
  
  use Sangoku::Util qw/validate_values datetime/;

  use constant TABLE_NAME => 'idle_talk';

  sub get {
    my ($class, $limit, $offset) = @_;

    my @rows = $class->db->search(TABLE_NAME, {}, {
        order_by => 'id DESC',
        defined $limit ? (limit => $limit) : (),
        defined $offset ? (offset => $offset) : (),
    });
    return \@rows;
  }

  sub add {
    my ($class, $args) = @_;
    validate_values($args => [qw/name icon message/]);

    $class->db->do_insert(TABLE_NAME, {
      %$args,
      time => datetime(),
    });
  }

  sub delete {
    my ($class, $id) = @_;
    $class->db->delete(TABLE_NAME, {id => $id});
  }

  __PACKAGE__->meta->make_immutable();
}

1;
