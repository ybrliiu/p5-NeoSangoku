package Sangoku::Model::Role::DB::RelatePlayer {

  use Mouse::Role;
  use Sangoku;
  with 'Sangoku::Model::Role::DB';

  requires 'TABLE_NAME';

  sub get_by_player_id {
    my ($class, $player_id) = @_;
    return $class->db->single($class->TABLE_NAME, {player_id => $player_id});
  }

}

1;
