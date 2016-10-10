package Sangoku::Service::Player::Mypage {

  use Mouse;
  use Sangoku;
  with 'Sangoku::Service::Role::Base';

  sub root {
    my ($class, $player_id) = @_;

    state $config = {
      log => {
        command_log => 6,
        map_log     => 6,
      },
      letter => {
        country => 15,
        invite  => 5,
        player  => 10,
        town    => 5,
        unit    => 5,
      },
    };

    my $player         = $class->model('Player')->get($player_id);
    my $unit           = $player->unit;
    my $countreis_hash = $class->model('Country')->get_all_to_hash();
    my $country        = $player->country($countreis_hash);
    my $towns          = $class->model('Town')->get_all();
    my $town           = $player->town;
    my $letter = {
      player  => $player->letter->get($config->{letter}{player}),
      unit    => $player->is_delong_unit ? $unit->letter->get($config->{letter}{unit}) : [],
      invite  => $player->invite->get($config->{letter}{invite}),
      country => $country->letter->get($config->{letter}{country}),
      town    => $town->letter->get($config->{letter}{town}),
    };

    return {
      player          => $player,
      command_log     => $player->command_log->get($config->{log}{command_log}),
      countries_hash  => $countreis_hash,
      country         => $country,
      unit            => $unit,
      towns           => $towns,
      map_data        => $class->model('Town')->get_all_for_map($towns),
      town            => $player->town,
      site            => $class->model('Site')->get(),
      map_log         => $class->model('MapLog')->get($config->{log}{map_log}),
      view_config     => $config,
      letter          => $letter,
    };
  }

  __PACKAGE__->meta->make_immutable();
}

1;
