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
    $self->service->input($json);
    $self->redirect_to('/player/mypage/command');
  }

  sub select {
    my ($self) = @_;
    my ($player_id, $json) = ($self->session('id'), $self->req->json);
    $json->{player_id} = $player_id;
    my $result = $self->service->select($json);
    my $html = $self->render_to_string($result->{next_page_name});
    $result->{render_html} = $html;
    $self->render(json => $result);
  }

}

1;
