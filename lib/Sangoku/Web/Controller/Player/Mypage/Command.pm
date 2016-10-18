package Sangoku::Web::Controller::Player::Mypage::Command {

  use Sangoku;
  use Mojo::Base 'Mojolicious::Controller';

  use Mojo::JSON qw/decode_json/;

  sub root {
    my ($self) = @_;
    my $player_id = $self->session('id');
    my $result = $self->service->root($player_id);
    $self->render(%$result);
  }

  sub input {
    my ($self) = @_;
    my ($player_id, $json) = ($self->session('id'), $self->req->json);
    $json->{player_id} = $player_id;

    my $hash = $self->service->input($json);
    use Data::Dumper;
    $self->app->log->warn(Dumper $hash);

    # need to choose otion
    if (exists $json->{next_page}) {
      my ($result, $stash, $error) = map { $hash->{$_} } qw/result stash error/;

      # when complete
      $self->redirect_to('/player/mypage/command') if $result->{complete};

      $self->stash(%$stash);
      $self->flash_error($error);
      my $html = $self->render_fill_error($result->{next_page_name}, {to_string => 1});
      $result->{render_html} = $html;
      $self->render(json => $result);
    }
    # dont need to choose option 
    else {
      $self->redirect_to('/player/mypage/command');
    }

  }

}

1;
