package Sangoku::Model::Player::Soldier {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB';

  use constant TABLE_NAME => 'player_soldier';

  sub create {
    my ($class, $id) = @_;
    $class->db->do_insert(TABLE_NAME, {player_id => $id});
  }

  __PACKAGE__->meta->make_immutable();
}

1;
