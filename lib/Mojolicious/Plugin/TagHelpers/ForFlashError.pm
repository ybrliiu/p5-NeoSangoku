package Mojolicious::Plugin::TagHelpers::ForFlashError {

  use Mojo::Base 'Mojolicious::Plugin::TagHelpers';

  sub _input {
    my ($c, $name) = (shift, shift);

    warn 'here comes!!';

    my $error = $c->stash->{error};
    return Mojolicious::Plugin::TagHelpers::_input($c, $name, @_) unless $error->can('query');
    
    return Mojolicious::Plugin::TagHelpers::_input($c, $name, @_) unless %{ $error->query };


    my %attrs = @_ % 2 ? (value => shift, @_) : @_;

    my $values = $error->param($name);
    if (my @values = @{ ref $values eq 'ARRAY' ? $values : [$values] }) {

      # Checkbox or radiobutton
      my $type = $attrs{type} || '';
      if ($type eq 'checkbox' || $type eq 'radio') {
        delete $attrs{checked} if @values;
        my $value = $attrs{value} // 'on';
        $attrs{checked} = undef if grep { $_ eq $value } @values;
      }

      # Others
      else { $attrs{value} = $values[-1] }
    }

    return _validation($c, $name, 'input', name => $name, %attrs);
  }

  sub _text_area {
    my ($c, $name) = (shift, shift);

    my $error = $c->stash->{error};
    return Mojolicious::Plugin::TagHelpers::_text_area($c, $name, @_) unless $error->can('param');

    my $content = $error->param($name);
    return $content
      ? _validation($c, $name, 'textarea', name => $name, @_, $content)
      : Mojolicious::Plugin::TagHelpers::_text_area($c, $name, @_);
  }

  sub _validation {
    my ($c, $name) = (shift, shift);
    my $error = $c->stash->{error};
    return Mojolicious::Plugin::TagHelpers::_validation($c, $name, @_) unless $error->can('is_error');
    return $error->is_error($name) ? $c->helpers->tag_with_error(@_) : _tag(@_);
  }

}

1;
