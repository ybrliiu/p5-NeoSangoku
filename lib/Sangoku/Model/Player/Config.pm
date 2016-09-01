package Sangoku::Model::Player::Config {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB';

  use constant TABLE_NAME => 'player_config';

  sub get {
    my ($class, $id) = @_;
    return $class->db->single(TABLE_NAME, {player_id => $id});
  }

  sub create {
    my ($class, $id) = @_;
    $class->db->do_insert(TABLE_NAME, {player_id => $id});
  }

  __PACKAGE__->meta->make_immutable();
}

1;
