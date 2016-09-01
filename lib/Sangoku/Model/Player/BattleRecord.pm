package Sangoku::Model::Player::BattleRecord {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB';

  use constant TABLE_NAME => 'player_battle_record';

  sub get {
    my ($class, $id) = @_;
    return $class->db->single(TABLE_NAME() => {player_id => $id});
  }

  __PACKAGE__->meta->make_immutable();
}

1;
