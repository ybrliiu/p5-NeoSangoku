package Sangoku::Model::Player::Config {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB';

  use constant TABLE_NAME => 'player_config';

  sub create {
    my ($class, $id) = @_;
    $class->db->do_insert(TABLE_NAME, {player_id => $id});
  }

  __PACKAGE__->generate_methods();

  __PACKAGE__->meta->make_immutable();
}

1;
