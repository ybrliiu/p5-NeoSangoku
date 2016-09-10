package Sangoku::Model::Role::DB::Thread {

  use Sangoku;
  use Mouse::Role;
  with 'Sangoku::Model::Role::DB';

  sub get {
    my ($class, $limit, $offset) = @_;

    my @columns = $class->db->search($class->TABLE_NAME, ref $class ? {$class->_add_condition} : {}, {
        order_by => 'id DESC',
        defined $limit ? (limit => $limit) : (),
        defined $offset ? (offset => $offset) : (),
    });
    return \@columns;
  }

}

1;
