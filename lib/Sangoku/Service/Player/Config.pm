package Sangoku::Service::Player::Config {

  use Mouse;
  use Sangoku;
  with 'Sangoku::Service::Role::Base';

  sub root {
    my ($class, $player_id) = @_;

    my $player = $class->model('Player')->get($player_id);

    return {
      player         => $player,
      country        => $player->country,
      command_record => $player->command_record,
      battle_record  => $player->battle_record,
    };
  }

  __PACKAGE__->meta->make_immutable();
}

1;
