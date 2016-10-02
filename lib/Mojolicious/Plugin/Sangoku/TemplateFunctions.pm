package Mojolicious::Plugin::Sangoku::TemplateFunctions {

  use Mojo::Base 'Mojolicious::Plugin';
  use Sangoku;

  sub register {
    my ($self, $app) = @_;

    $app->helper($_ => $self->can("_$_")) for qw/get_cookie show_error/;
  }

  sub _get_cookie {
    my ($c, $key) = @_;
    return $c->cookie($key);
  }

  sub _show_error {
    my ($c, @param_names) = @_;

    my $str = '';
    my $error = $c->stash->{error};
    my $is_exist = grep { $error->is_error($_) } @param_names;
    if ($is_exist) {
      $str .= qq{<ul class="error-list">\n};

      for my $param_name (@param_names) {
        for ( $error->get_error_messages_from_param($param_name) ) {
          $str .= qq{  <li class="red">$_</li>\n};
        }
      }

      $str .= qq{</ul>\n};
    }

    return $c->b($str);
  }

}

1;
