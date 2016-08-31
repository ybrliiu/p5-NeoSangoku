package Sangoku::Model::Unit {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB';

  use Sangoku::Util qw/validate_keys/;

  use constant TABLE_NAME => 'unit';

  sub get {
    my ($class, $id) = @_;
    $class->db->single(TABLE_NAME() => {id => $id});
  }

  sub create {
    my ($class, %args) = @_;
    validate_keys(\%args => [qw/id name country_name message/]);
    $class->db->do_insert(TABLE_NAME() => \%args);
  }

  sub delete {
    my ($class, $id) = @_;
    $class->db->delete(TABLE_NAME() => {id => $id});
  }

  __PACKAGE__->meta->make_immutable();
}

1;
