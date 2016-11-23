package Sangoku::Model::Unit::Members {

  use Mouse;
  use Sangoku;
  with 'Sangoku::Model::Role::DB::RelatePlayer';

  use constant TABLE_NAME => 'unit_members';

  has 'id' => (is => 'ro', isa => 'Str', required => 1);

  sub get {
    my ($self) = @_;
    my @rows = $self->db->search(TABLE_NAME, {unit_id => $self->id});
    return \@rows;
  }

  sub add {
    my ($self, $player) = @_;
    $self->db->do_insert(TABLE_NAME, {
      unit_id      => $self->id,
      player_id    => $player->id,
      player_name  => $player->name,
      country_name => $player->country_name,
    });
  }

  __PACKAGE__->meta->make_immutable();
}

1;
