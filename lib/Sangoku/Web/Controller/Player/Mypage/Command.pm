package Sangoku::Web::Controller::Player::Mypage::Command {

  use Sangoku;
  use Mojo::Base 'Mojolicious::Controller';

  sub root {
    my ($self) = @_;
    my $player_id = $self->session('id');
    my $result = $self->service->root($player_id);
    $self->render(%$result);
  }

}

1;
