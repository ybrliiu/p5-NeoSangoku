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

  sub change_icon {
    my ($self) = @_;
    my $player_id = $self->session('id');
    my $error = $self->service->change_icon({
      player_id => $player_id,
      icon      => $self->param('icon'),
    });
    $self->flash_error($error);
    $self->redirect_to('/player/config');
  }

  sub change_equipments_name {
    my ($self) = @_;
    my $player_id = $self->session('id');
    my $params = $self->req->params->to_hash;
    $params->{player_id} = $player_id;
    my $error = $self->service->change_equipments_name($params);
    $self->flash_error($error);
    $self->redirect_to('/player/config');
  }

  sub change_loyalty {
    my ($self) = @_;
    my $player_id = $self->session('id');
    my $error = $self->service->change_loyalty({
      player_id => $player_id,
      loyalty   => $self->param('loyalty'),
    });
    $self->flash_error($error);
    $self->redirect_to('/player/config');
  }

  sub set_profile {
    my ($self) = @_;
    my $player_id = $self->session('id');
    my $error = $self->service->set_profile({
      player_id => $player_id,
      profile   => $self->param('profile'),
    });
    $self->flash_error($error);
    $self->redirect_to('/player/config');
  }

}

1;
