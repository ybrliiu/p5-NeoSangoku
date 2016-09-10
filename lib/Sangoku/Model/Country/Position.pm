package Sangoku::Model::Country::Position {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB';

  use Sangoku::Util qw/validate_values/;
  
  use constant TABLE_NAME => 'country_position';

  sub create {
    my ($class, $args) = @_;
    validate_values($args => [qw/name king_id/]);

    $class->db->insert(TABLE_NAME, {
      country_name => $args->{name},
      king_id      => $args->{king_id},
    });
  }

  __PACKAGE__->meta->make_immutable();
}

1;
