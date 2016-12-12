package Sangoku::Model::Role::DB::Thread {

  use Sangoku;
  use Mouse::Role;
  with 'Sangoku::Model::Role::DB';

  use constant DEFAULT_PER_PAGE => 5;

  has 'per_page' => (is => 'ro', isa => 'Str', default => DEFAULT_PER_PAGE);

  requires 'number_of_threads';

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
    my ($self, $page, $threads) = @_;
    if ( ref $threads eq 'ARRAY' ) {
      my $num = $page * $self->per_page;
      [ map { $threads->[$_] // () } $num .. $num + $self->per_page - 1 ];
    } else {
      $self->get($self->per_page, $page * $self->per_page);
    }
  }

  sub max_page {
    my ($self) = @_;
    return int( ($self->number_of_threads - 1) / $self->per_page );
  }

}

1;
