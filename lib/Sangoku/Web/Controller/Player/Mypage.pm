package Sangoku::Web::Controller::Player::Mypage {

  use Mojo::Base 'Mojolicious::Controller';
  use Sangoku;

  # タイムアウトにかかる時間
  # nginx, apache側の keep-alive の値も影響するので注意
  use constant TIMEOUT => 3600;

  sub root {
    my ($self) = @_;
    my $player_id = $self->session('id');
    my $result = $self->service->root($player_id);
    $self->stash(%$result);
    $self->render();
  }

  sub _write_letter {
    my ($self, $json) = @_;
    my $player_id = $self->session('id');
    $json->{sender_id} = $player_id;
    $json->{message} =~ s/(\n|\r\n|\r)/<br>/g;
    $self->service->write_letter($json);
  }

  sub _emit_event {
    my ($self, $letter_data) = @_;
    $self->events->emit(chat => $letter_data);
  }

  # 接続が切れた後の処理(イベントの購読をやめる
  sub _finish_connect {
    my ($self, $cb) = @_;
    $self->on(finish => sub {
      my ($c) = @_;
      $c->events->unsubscribe(chat => $cb);
    });
  }

  sub _once_event {
    my ($self) = @_;
    $self->events->once(chat => sub {
      my ($event, $letter_data) = @_;
      $self->render(json => $letter_data);
    });
  }

  sub channel {
    my ($self) = @_;

    $self->inactivity_timeout(TIMEOUT);

    $self->on(json => sub {
      my ($c, $json) = @_;

      return $self->send({text => 'ack'}) if exists $json->{ping};

      my $letter_data = $self->_write_letter($json);
      $self->_emit_event($letter_data);
    });

    my $cb = $self->events->on(chat => sub {
      my ($event, $letter_data) = @_;
      $self->send({json => $letter_data});
    });

    $self->_finish_connect($cb);
  }

  sub polling {
    my ($self) = @_;
    $self->inactivity_timeout(TIMEOUT);
    $self->render_later();

    my $json = $self->req->json;
    $self->render(text => 'ack') if exists $json->{ping};

    my $cb = $self->_once_event();
    $self->_finish_connect($cb);
  }

  sub send_letter {
    my ($self) = @_;
    my $letter_data = $self->_write_letter($self->req->json);
    $self->_emit_event($letter_data);
    $self->render(json => {status => 'succsess'});
  }

}

1;
