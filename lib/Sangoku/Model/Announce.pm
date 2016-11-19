package Sangoku::Model::Announce {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB';

  use Sangoku::Util qw/date/;

  use constant TABLE_NAME => 'announce';

  sub get {
    my ($class, $limit) = @_;
    my @rows = $class->db->search(TABLE_NAME, {}, {
      order_by => 'id DESC',
      defined $limit ? (limit => $limit) : (),
    });
    return \@rows;
  }

  sub add {
    my ($class, $message) = @_;
    $class->db->do_insert(TABLE_NAME, {
      message => $message,
      date    => date(),
    });
  }

}

1;
