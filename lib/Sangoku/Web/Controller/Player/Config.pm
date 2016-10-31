package Sangoku::Web::Controller::Player::Config {

  use Mojo::Base 'Mojolicious::Controller';
  use Sangoku;

  sub root {
    my ($self) = @_;
    my $player_id = $self->session('id');
    my $result = $self->service->root($player_id);
    $self->flash_error();
    $self->stash(%$result);
    $self->render_fill_error();
  }

}

1;
