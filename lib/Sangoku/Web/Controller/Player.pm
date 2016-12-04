package Sangoku::Web::Controller::Player {

  use Mojo::Base 'Sangoku::Web::Controller';
  use Sangoku;

  sub auth {
    my ($self) = @_;

    my ($id, $pass, $store) = map { $self->param($_) } qw/id pass store/;
    
    # auth if exist session
    my $session = $self->session('id');
    return 1 if $session;

    my $error = $self->service->auth($id, $pass);
    if ($error->has_error) {
      $self->flash_error($error, {path => '/'});
      $self->redirect_to('/');
      return ();
    } else {
      $self->session(id => $id);
      if ($store) {
        my $status = {max_age => 100000000, path => '/'};
        $self->cookie(id => $id, $status);
        $self->cookie(pass => $pass, $status);
      }
      return 1;
    }
  }

  sub login {
    my ($self) = @_;
    $self->redirect_to('/player/mypage');
  }

  sub logout {
    my ($self) = @_;
    # encode_utf8 しないと Mojo::Reactor::EV でエラーが起きる
    $self->cookie(logout => Encode::encode_utf8('ログアウトしました。'), {max_age => 1, path => '/'});
    $self->session(expires => 1);
    $self->redirect_to('/');
  }

  sub command_log {
    my ($self) = @_;
    my $player_id = $self->session('id');
    my $result = $self->service->command_log($player_id);
    $self->stash(%$result);
    $self->render();
  }

}

1;
