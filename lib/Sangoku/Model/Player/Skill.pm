package Sangoku::Model::Player::Skill {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB';

  use constant TABLE_NAME => 'player_skill';

  has 'id' => (is => 'ro', isa => 'Str', required => 1);

  sub get {
    my ($self) = @_;
    my @columns = $self->db->search(TABLE_NAME() => {player_id => $self->id});
    return \@columns;
  }

  sub get_skills {
    my ($self, $category) = @_;
    my @columns = $self->db->search(TABLE_NAME() => {
      player_id      => $self->id,
      skill_category => $category,
    });
    return \@columns;
  }

  sub add {
    my ($self, $category, $name) = @_;
    $self->db->do_insert(TABLE_NAME() => {
      player_id      => $self->id,
      skill_category => $category,
      skill_name     => $name,
    });
  }

}

1;
