package Sangoku::Model::Country::Position {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB';
  
  use constant TABLE_NAME => 'country_position';

  sub get {
    my ($class, $name) = @_;
    $class->db->single(TABLE_NAME, {name => $name});
  }

  __PACKAGE__->meta->make_immutable();
}

1;
