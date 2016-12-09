package Sangoku::Model::Player::Guard {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB::Player';

  use Sangoku::Util qw/validate_values/;

  use constant TABLE_NAME => 'player_guard';

  sub create {
    my ($class, $args) = @_;
    validate_values($args => [qw/player_id power/]);
    $class->db->do_insert(TABLE_NAME, $args);
  }

  __PACKAGE__->meta->make_immutable();
}

1;
