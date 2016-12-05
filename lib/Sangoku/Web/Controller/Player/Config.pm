package Sangoku::Web::Controller::Player::Config {

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

  sub change_icon {
    my ($self) = @_;
    my $player_id = $self->session('id');
    my $error = $self->service->change_icon({
      player_id => $player_id,
      icon      => $self->param('icon'),
    });
    $error->has_error
      ? $self->flash_error($error)
      : $self->flash(success => '変更完了しました。');
    $self->redirect_to('/player/config');
  }

  sub change_equipments_name {
    my ($self) = @_;
    my $player_id = $self->session('id');
    my $params = $self->req->params->to_hash;
    $params->{player_id} = $player_id;
    my $error = $self->service->change_equipments_name($params);
    $error->has_error
      ? $self->flash_error($error)
      : $self->flash(success => '変更完了しました。');
    $self->redirect_to('/player/config');
  }

  sub change_loyalty {
    my ($self) = @_;
    my $player_id = $self->session('id');
    my $error = $self->service->change_loyalty({
      player_id => $player_id,
      loyalty   => $self->param('loyalty'),
    });
    $error->has_error
      ? $self->flash_error($error)
      : $self->flash(success => '変更完了しました。');
    $self->redirect_to('/player/config');
  }

  sub change_win_message {
    my ($self) = @_;
    my $player_id = $self->session('id');
    my $error = $self->service->change_win_message({
      player_id   => $player_id,
      win_message => $self->param('win_message'),
    });
    $error->has_error
      ? $self->flash_error($error)
      : $self->flash(success => '変更完了しました。');
    $self->redirect_to('/player/config');
  }

  sub set_profile {
    my ($self) = @_;
    my $player_id = $self->session('id');
    my $error = $self->service->set_profile({
      player_id => $player_id,
      profile   => $self->param('profile'),
    });
    $error->has_error
      ? $self->flash_error($error)
      : $self->flash(success => 'プロフィールを更新しました。');
    $self->redirect_to('/player/config');
  }

}

1;
