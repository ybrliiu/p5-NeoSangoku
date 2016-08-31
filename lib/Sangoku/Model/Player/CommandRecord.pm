package Sangoku::Model::Player::CommandRecord {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB';

  use constant TABLE_NAME => 'player_book';

  has 'player_id' => (is => 'ro', isa => 'Str', required => 1);

  sub get {
    my ($self) = @_;
  }

  sub add {
  }

}

1;
