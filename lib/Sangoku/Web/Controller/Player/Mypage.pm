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

}

1;
