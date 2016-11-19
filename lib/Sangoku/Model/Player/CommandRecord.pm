package Sangoku::Model::Player::CommandRecord {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB';

  use constant TABLE_NAME => 'player_command_record';

  has 'id' => (is => 'ro', isa => 'Str', required => 1);

  sub get {
    my ($self) = @_;
    my @rows = $self->db->search(TABLE_NAME, {player_id => $self->id});
    return \@rows;
  }

  sub add {
    my ($self, $name) = @_;
    $self->db->do_insert(TABLE_NAME, {
      player_id     => $self->id,
      command_name  => $name,
      execute_count => 1,
    });
  }

  sub count {
    my ($self, $name) = @_;

    my $row = $self->db->single(TABLE_NAME, {
      player_id    => $self->id,
      command_name => $name,
    });

    defined $row ? $row->update({execute_count => $row->execute_count + 1}) : $self->add($name);
  }

  sub get_by_command_name {
    my ($class, $name) = @_;
    my @rows = $class->db->search(TABLE_NAME, {command_name => $name});
    return \@rows;
  }

  __PACKAGE__->meta->make_immutable();
}

1;
