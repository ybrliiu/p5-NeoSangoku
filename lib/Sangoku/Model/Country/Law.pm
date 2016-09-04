package Sangoku::Model::Country::Law {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB';

  use Sangoku::Util qw/validate_values datetime/;

  use constant TABLE_NAME => 'country_law';

  has 'name' => (is => 'ro', isa => 'Str', required => 1);

  sub get {
    my ($self) = @_;
    my @columns = $self->db->search(TABLE_NAME, {country_name => $self->name}, {order_by => 'id DESC'});
    return \@columns;
  }

  sub add {
    my ($self, $args) = @_;
    validate_values($args => [qw/sender title message/]);

    $self->db->do_insert(TABLE_NAME, {
      country_name => $self->name,
      name         => $args->{sender}->name,
      title        => $args->{title},
      message      => $args->{message},
    });
  }

  sub delete {
    my ($self, $id) = @_;
    $self->db->delete(TABLE_NAME, {id => $id});
  }

  __PACKAGE__->meta->make_immutable();
}

1;
