package Sangoku::Model::IconUploader {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB';

  use Sangoku::Util qw/datetime/;

  use constant TABLE_NAME => 'icon_uploader';

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
    my ($class, $tag) = @_;
    $class->db->do_insert(TABLE_NAME, {
      tag  => $tag,
      time => datetime(), 
    });
  }

  sub get_by_tag {
    my ($class, $tag) = @_;
    my @rows = $class->db->search(TABLE_NAME, {tag => $tag}, {order_by => 'id DESC'});
    return \@rows;
  }

  __PACKAGE__->meta->make_immutable();
}

1;
