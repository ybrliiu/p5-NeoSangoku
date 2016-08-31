package Sangoku::Model::Player::Weapon {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB';

  use Sangoku::Util qw/validate_keys/;

  use constant TABLE_NAME => 'player_weapon';

  sub get {
    my ($class, $player_id) = @_;
    return $class->db->single(TABLE_NAME() => {player_id => $player_id});
  }

  sub create {
    my ($class, $args) = @_;
    validate_keys($args => [qw/player_id power/]);
    $class->db->do_insert(TABLE_NAME() => $args);
  }

  __PACKAGE__->meta->make_immutable();
}

1;
