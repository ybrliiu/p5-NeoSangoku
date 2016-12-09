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

  sub conference {
    my ($self) = @_;
    my $player_id = $self->session('id');
    my $result = $self->service->conference($player_id);
    $self->flash_error();
    $self->stash($result);
    $self->render_fill_error();
  }

  sub create_conference_thread {
    my ($self) = @_;
    my $player_id = $self->session('id');
    my $error = $self->service->create_conference_thread({
      player_id => $player_id,
      title     => $self->param('title'),
      message   => $self->param('message'),
    });
    $error->has_error
      ? $self->flash_error($error)
      : $self->flash(success => '投稿完了しました。');
    $self->redirect_to('/player/country/conference');
  }

}

1;
