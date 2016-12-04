package Sangoku::Web::Controller {

  use Mojo::Base 'Mojolicious::Controller';
  use Sangoku;

  # override
  sub render {
    my $self = shift;
    $self->stash({
      JS_FILES  => [],
      CSS_FILES => [],
    });
    $self->SUPER::render(@_);
  }

}

1;
