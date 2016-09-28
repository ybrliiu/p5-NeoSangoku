package Mojolicious::Plugin::SangokuTagHelpers {

  use Mojo::Base 'Mojolicious::Plugin::TagHelpers';

  sub _validation {
    my ($c, $name) = (shift, shift);
    return _tag(@_) unless $c->error->is_error($name)
      && $c->validation->has_error($name);
    return $c->helpers->tag_with_error(@_);
  }

}

1;
