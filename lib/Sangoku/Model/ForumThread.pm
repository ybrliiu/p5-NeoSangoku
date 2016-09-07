package Sangoku::Model::ForumThread {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB';

  use Sangoku::Util qw/validate_values datetime/;

  use constant TABLE_NAME => 'forum_thread';

  sub get {
    my ($class, $limit, $offset) = @_;

    my @columns = $class->db->search(TABLE_NAME, {}, {
        order_by => 'id DESC',
        defined $limit ? (limit => $limit) : (),
        defined $offset ? (offset => $offset) : (),
    });
    return \@columns;
  }

  sub add {
    my ($class, $args) = @_;
    validate_values($args => [qw/title name message icon/]);

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
