package Sangoku::Web::Controller::Player::MyPage {

  use Mojo::Base 'Mojolicious::Controller';
  use Sangoku;

  sub root {
    my ($self) = @_;
    my $player_id = $self->session('id');
    my $result = $self->service->root();
    $self->stash(%$result);
    $self->render();
  }

  sub channel {
    my ($self) = @_;
  }

}

1;
