package Sangoku::Model::Unit::Members {

  use Mouse;
  use Sangoku;
  with 'Sangoku::Model::Role::DB';

  use constant TABLE_NAME => 'unit_members';

  has 'id' => (is => 'ro', isa => 'Str', required => 1);

  sub get {
    my ($self) = @_;
    my @columns = $self->db->search(TABLE_NAME, {unit_id => $self->id});
    return \@columns;
  }

  sub add {
    my ($self, $player) = @_;
    $self->db->do_insert(TABLE_NAME, {
      unit_id     => $self->id,
      player_id   => $player->id,
      player_name => $player->name,
    });
  }

  sub get_by_player_id {
    my ($class, $player_id) = @_;
    return $class->db->single(TABLE_NAME, {player_id => $player_id});
  }

  __PACKAGE__->meta->make_immutable();
}

1;