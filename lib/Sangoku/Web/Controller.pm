package Sangoku::Web::Controller {

  use Mojo::Base 'Mojolicious::Controller';
  use Sangoku;

  # override
  sub render {
    my $self = shift;
    $self->SUPER::render(@_, JS_FILES => [], CSS_FILES => []);
  }

}

1;
