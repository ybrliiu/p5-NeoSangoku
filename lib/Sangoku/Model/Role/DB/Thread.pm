package Sangoku::Model::Role::DB::Thread {

  use Sangoku;
  use Mouse::Role;
  with 'Sangoku::Model::Role::DB';

  sub _additional_condition {
    my ($self) = @_;

    return () unless ref $self;

    # if Sangoku::Model::Country::ConferenceThread
    return (country_name => $self->name);
  }

  sub get {
    my ($class, $limit, $offset) = @_;
    my @rows = $class->db->search($class->TABLE_NAME, {$class->_additional_condition}, {
        order_by => 'id DESC',
        defined $limit ? (limit => $limit) : (),
        defined $offset ? (offset => $offset) : (),
    });
    return \@rows;
  }

  sub get_by_page {
    my ($class, $page, $thread_num) = @_;
    $class->get($thread_num, $page * $thread_num);
  }

}

1;
