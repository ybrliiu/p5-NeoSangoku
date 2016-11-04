package Sangoku::Web::Controller::Player::Mypage {

  use Mojo::Base 'Mojolicious::Controller';
  use Sangoku;

  sub root {
    my ($self) = @_;
    my $player_id = $self->session('id');
    my $result = $self->service->root($player_id);
    $self->stash(%$result);
    $self->render();
  }

  sub channel {
    my ($self) = @_;

    $self->inactivity_timeout(600);

    # JSONオブジェクトをWebSocketを通して受ける
    $self->on(json => sub {
      my ($c, $json) = @_;
      my $player_id = $self->session('id');
      $json->{sender_id} = $player_id;
      $json->{message} =~ s/(\n|\r\n|\r)/<br>/g;
      my $letter_data = $c->service->write_letter($json);
      $c->events->emit(chat => $letter_data); # イベントを発行
    });

    # jsonをブラウザ側に送る
    my $cb = $self->events->on(
      chat => sub {
        my ($event, $letter_data) = @_;
        $self->send({json => $letter_data});
      }
    );
    
    # 接続切れた後の処理
    $self->on(finish => sub {
      my ($c) = @_;
      $c->events->unsubscribe(chat => $cb);
    });

  }

  # websocket の代わり
  sub check_new_letter {
    my ($self) = @_;
    my ($player_id, $json) = ($self->session('id'), $self->req->json);
    $json->{player_id} = $player_id;

    my $result = $self->service->check_new_letter($json);
    my $letter_data = $result->{letter};
    $self->render(json => +{
      %{ $result->{check} },
      (
        map {
          if (exists $letter_data->{$_}) {
            "${_}_letter" => $self->render_to_string('/parts/letter', letters => $letter_data->{$_})
          } else {
            ()
          }
        } keys %$letter_data
      ),
    });
  }

  sub send_letter {
    my ($self) = @_;
    my $player_id = $self->session('id');
    my $json = $self->req->json;
    $json->{sender_id} = $player_id;
    $json->{message} =~ s/(\n|\r\n|\r)/<br>/g;
    my $letter_data = $self->service->write_letter($json);
    $self->render(json => $letter_data);
  }

}

1;
