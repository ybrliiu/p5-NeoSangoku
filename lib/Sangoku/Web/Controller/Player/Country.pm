package Sangoku::Web::Controller::Player::Country {

  use Mojo::Base 'Sangoku::Web::Controller';
  use Sangoku;

  sub root {
    my ($self) = @_;
    my $player_id = $self->session('id');
    my $result = $self->service->root($player_id);
    $self->stash($result);
    $self->render();
  }

  sub member {
    my ($self) = @_;
    my $player_id = $self->session('id');
    my $result = $self->service->member($player_id);
    $self->stash($result);
    $self->render();
  }

}

1;
