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

    # JSONオブジェクトをWebSocketを通して受ける
    $self->on(json => sub {
      my ($c, $json) = @_;
      my $result = $c->service->input_letter($json);
      my %new_json = (
        type => $json->{type},
      );
      $c->events->emit(chat => \%new_json); # イベントを発行
    });

    # jsonをブラウザ側に送る
    my $cb = $self->events->on(
      chat => sub {
        my ($event, $json) = @_;
        $self->send({json => $json});
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
