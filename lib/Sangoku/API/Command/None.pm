package Sangoku::API::Command::None {

  use Mouse;
  use Sangoku;

  has 'name' => (is => 'ro', isa => 'Str', default => '何もしない');

  with 'Sangoku::API::Command::Base';

  sub execute {
    my ($self, $player) = @_;
    $player->update({delete_turn => $player->delete_turn + 1});
  }

  __PACKAGE__->meta->make_immutable();
}

1;
