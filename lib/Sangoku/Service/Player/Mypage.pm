package Sangoku::Service::Player::Mypage {

  use Mouse;
  use Sangoku;
  with 'Sangoku::Service::Role::Base';

  sub root {
    my ($class, $id) = @_;

    my $players_hash   = $class->model('Player')->get_all_to_hash();
    my $player         = $players_hash->{$id};
    my $countreis_hash = $class->model('Country')->get_all_to_hash();
    my $towns          = $class->model('Town')->get_all();

    return {
      players_hash   => $players_hash,
      player         => $player,
      command_log    => $player->command_log->get(6),
      countries_hash => $countreis_hash,
      country        => $player->country($countreis_hash),
      towns          => $towns,
      map_data       => $class->model('Town')->get_all_for_map($towns),
      town           => $player->town,
      site           => $class->model('Site')->get(),
      map_log        => $class->model('MapLog')->get(6),
    };
  }

  __PACKAGE__->meta->make_immutable();
}

1;
