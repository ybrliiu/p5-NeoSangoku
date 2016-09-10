package Sangoku::Model::Unit {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB';

  use Sangoku::Util qw/validate_values/;

  use constant TABLE_NAME => 'unit';

  sub create {
    my ($class, $args) = @_;
    validate_values($args => [qw/leader name message/]);

    $class->db->do_insert(TABLE_NAME, {
      id           => $args->{leader}->id,
      country_name => $args->{leader}->country_name,
      name         => $args->{name},
      message      => $args->{message},
    });
  }

  __PACKAGE__->meta->make_immutable();
}

1;
