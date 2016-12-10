package Sangoku::Web::Controller::Player::Unit {

  use Mojo::Base 'Sangoku::Web::Controller';
  use Sangoku;

  sub root {
    my ($self) = @_;
    my $player_id = $self->session('id');
    my $result = $self->service->root($player_id);
    $self->flash_error();
    $self->stash(%$result);
    $self->render_fill_error();
  }

  sub break {
    my ($self) = @_;
    my $player_id = $self->session('id');
    $self->service->break($player_id);
    $self->flash(success => '部隊を解散しました。');
    $self->redirect_to('/player/unit');
  }

  sub change_info {
    my ($self) = @_;
    my $player_id = $self->session('id');
    my $param = $self->req->params->to_hash();
    $param->{player_id} = $player_id;
    my $error = $self->service->change_info($param);
    $error->has_error
      ? $self->flash_error($error)
      : $self->flash(success => '部隊情報を変更しました。');
    $self->redirect_to('/player/unit');
  }

  sub create {
    my ($self) = @_;
    my $player_id = $self->session('id');
    my $param = $self->req->params->to_hash();
    $param->{player_id} = $player_id;
    my $error = $self->service->create($param);
    $error->has_error
      ? $self->flash_error($error)
      : $self->flash(success => '部隊を作成しました。');
    $self->redirect_to('/player/unit');
  }

  sub fire {
    my ($self) = @_;
    my $player_id = $self->session('id');
    my $param = $self->req->params->to_hash();
    $param->{player_id} = $player_id;
    $self->service->fire($param);
    $self->flash(success => '解雇しました。');
    $self->redirect_to('/player/unit');
  }

  sub join {
    my ($self) = @_;
    my $player_id = $self->session('id');
    my $param = $self->req->params->to_hash();
    $param->{player_id} = $player_id;
    $param->{unit_id} //= undef;
    my $error = $self->service->join($param);
    $error->has_error
      ? $self->flash_error($error)
      : $self->flash(success => '部隊に入隊しました。');
    $self->redirect_to('/player/unit');
  }

  sub switch_join_permit {
    my ($self) = @_;
    my $player_id = $self->session('id');
    $self->service->switch_join_permit($player_id);
    $self->flash(success => '入隊制限を切り替えました。');
    $self->redirect_to('/player/unit');
  }

  sub quit {
    my ($self) = @_;
    my $player_id = $self->session('id');
    $self->service->quit($player_id);
    $self->flash(success => '部隊から離脱しました。');
    $self->redirect_to('/player/unit');
  }

}

1;
