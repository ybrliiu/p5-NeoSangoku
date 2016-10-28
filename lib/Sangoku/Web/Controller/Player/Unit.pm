package Sangoku::Web::Controller::Player::Unit {

  use Mojo::Base 'Mojolicious::Controller';
  use Sangoku;

  sub root {
    my ($self) = @_;
    my $player_id = $self->session('id');
    my $result = $self->service->root($player_id);
    $self->stash(%$result);
    $self->render();
  }

  sub break {
    my ($self) = @_;
    my $player_id = $self->session('id');
    $self->service->break($player_id);
    $self->redirect_to('/player/unit');
  }

  sub change_info {
    my ($self) = @_;
    my $player_id = $self->session('id');
    my $param = $self->req->params->to_hash();
    $param->{player_id} = $player_id;
    my $error = $self->service->change_info($param);
    $self->flash_error($error);
    $self->redirect_to('/player/unit');
  }

  sub create {
    my ($self) = @_;
    my $player_id = $self->session('id');
    my $param = $self->req->params->to_hash();
    $param->{player_id} = $player_id;
    my $error = $self->service->create($param);
    $self->flash_error($error);
    $self->redirect_to('/player/unit');
  }

  sub fire {
    my ($self) = @_;
    my $player_id = $self->session('id');
    my $param = $self->req->params->to_hash();
    $param->{player_id} = $player_id;
    $self->service->fire($param);
    $self->redirect_to('/player/unit');
  }

  sub join {
    my ($self) = @_;
    my $player_id = $self->session('id');
    my $param = $self->req->params->to_hash();
    $param->{player_id} = $player_id;
    my $error = $self->service->join($param);
    $self->flash_error($error);
    $self->redirect_to('/player/unit');
  }

  sub switch_join_permit {
    my ($self) = @_;
    my $player_id = $self->session('id');
    $self->service->switch_join_permit($player_id);
    $self->redirect_to('/player/unit');
  }

  sub quit {
    my ($self) = @_;
    my $player_id = $self->session('id');
    $self->service->quit($player_id);
    $self->redirect_to('/player/unit');
  }

}

1;
