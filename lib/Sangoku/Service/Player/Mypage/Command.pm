package Sangoku::Service::Player::Mypage::Command {

  use Mouse;
  use Sangoku;
  with 'Sangoku::Service::Role::Base';

  sub root {
    my ($class, $player_id) = @_;
    return {
      command => $class->model('Player::Command')->new(id => $player_id)->get_all(),
    };
  }

}

1;
