package Sangoku::Web::Controller::Player::Mypage {

  use Mojo::Base 'Sangoku::Web::Controller';
  use Sangoku;

  # タイムアウトにかかる時間
  # nginx, apache側の keepalive_timeout, proxy_read_timeout の値も影響する
  use constant TIMEOUT => 3600;

  sub root {
    my ($self) = @_;
    my $player_id = $self->session('id');
    my $result = $self->service->root($player_id);
    $self->stash(%$result);
    $self->render();
  }

  sub letter_log {
    my ($self) = @_;
    my $player_id = $self->session('id');
    my $result = $self->service->letter_log($player_id);
    $self->stash(%$result);
    $self->render();
  }

  sub _write_letter {
    my ($self, $json) = @_;
    my $player_id = $self->session('id');
    $json->{sender_id} = $player_id;
    $self->service->write_letter($json);
  }

  sub _write_read_letter_id {
    my ($self, $json) = @_;
    $self->service->write_read_letter_id({
      id        => $json->{id},
      type      => $json->{type},
      player_id => $self->session('id'),
    });
  }

  sub _emit_event {
    my ($self, $letter_data, $sender) = @_;
    $self->events->emit(chat => ($letter_data, $sender));
  }

  # 接続が切れた後の処理(イベントの購読をやめる
  sub _finish_connect {
    my ($self, $cb) = @_;
    $self->on(finish => sub {
      my ($c) = @_;
      $c->events->unsubscribe(chat => $cb);
    });
  }

  sub _subscride_event {
    my ($self, $type) = @_;
    my $player_id = $self->session('id');
    my $player = $self->service->get_player($player_id);
    return sub {
      my ($event, $letter_data, $sender) = @_;
      my $is_player_and_receiver_same
        = $player->name eq $letter_data->{receiver_name} && $letter_data->{type} eq 'player';
      if (
           $is_player_and_receiver_same
        || $player->unit_id eq $sender->unit_id
        || $player->country_name eq $sender->country_name
        || $player->town_name eq $sender->town_name
      ) {
        $type eq 'websocket' ? $self->send({json => $letter_data}) : $self->render(json => $letter_data);
      }
    };
  }

  sub channel {
    my ($self) = @_;

    $self->inactivity_timeout(TIMEOUT);

    {
      my %switch_mode = (
        ping         => sub { $self->send({text => 'ack'}) },
        write_letter => sub {
          my ($json) = @_;
          my ($letter_data, $sender) = $self->_write_letter($json);
          $self->_emit_event($letter_data, $sender);
        },
        write_read_letter_id => sub {
          my ($json) = @_;
          $self->_write_read_letter_id($json);
        },
      );

      $self->on(json => sub {
        my ($c, $json) = @_;
        $switch_mode{$json->{mode}}->($json);
      });
    }

    my $cb = $self->events->on(chat => $self->_subscride_event('websocket'));
    $self->_finish_connect($cb);
  }

  sub polling {
    my ($self) = @_;
    $self->inactivity_timeout(TIMEOUT);
    $self->render_later();
    my $cb = $self->events->once(chat => $self->_subscride_event('long_polling'));
    $self->_finish_connect($cb);
  }

  sub write_letter {
    my ($self) = @_;
    my ($letter_data, $sender) = $self->_write_letter($self->req->json);
    $self->_emit_event($letter_data, $sender);
    $self->render(json => {status => 'succsess'});
  }

  sub write_read_letter_id {
    my ($self) = @_;
    $self->_write_read_letter_id($self->req->json);
    $self->render(json => {status => 'succsess'});
  }

}

1;
