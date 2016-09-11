package Sangoku::Web::Controller::Root {

  use Sangoku;
  use Mojo::Base 'Mojolicious::Controller';

  sub root {
    my ($self) = @_;
    $self->render(msg => 'Welcome to the Mojolicious real-time web framework!');
  }

}

1;
