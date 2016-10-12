package Sangoku::Service::Player::Mypage::Command {

  use Mouse;
  use Sangoku;
  with 'Sangoku::Service::Role::Base';

  use Sangoku::Util qw/validate_values/;

  sub root {
    my ($class, $player_id) = @_;
    return {
      command => $class->model('Player::Command')->new(id => $player_id)->get_all(),
    };
  }

  sub input {
    my ($class, $args) = @_;
    validate_values($args => [qw/player_id command_name/]);

    my $model = $class->model('Command');
    $model->input($args);
  }

}

1;
