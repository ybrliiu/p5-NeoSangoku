package Sangoku::Web::Controller::Outer::Regist {

  use Sangoku;
  use Mojo::Base 'Mojolicious::Controller';

  sub root {
    my ($self) = @_;
    $self->flash_error();
    $self->render_fill_error();
  }

  sub regist {
    my ($self) = @_;
    my $param = $self->req->params->to_hash();
    my $validator = Sangoku::Validator->new($param);
    $self->flash_error($validator);
    $self->redirect_to('/outer/regist');
  }

}

1;
