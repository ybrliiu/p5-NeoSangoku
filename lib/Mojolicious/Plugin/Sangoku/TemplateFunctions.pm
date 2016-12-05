package Mojolicious::Plugin::Sangoku::TemplateFunctions {

  use Mojo::Base 'Mojolicious::Plugin';
  use Sangoku;

  sub register {
    my ($self, $app) = @_;
    $app->helper($_ => $self->can("_$_")) for qw/get_cookie show_error show_all_error show_success_message/;
  }

  sub _get_cookie {
    my ($c, $key) = @_;
    return $c->cookie($key);
  }

  sub _show_error {
    my ($c, @param_names) = @_;

    my $str = '';
    my $error = $c->stash('error');
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

  sub _show_all_error {
    my ($c, $option) = @_;
    my $error = $c->stash('error');
    my $str = '';
    if ($error->has_error) {
      if ($option->{grid}) {
        $str .= qq{<div class="grid-right width-100pc">}
          . _show_all_error_html($error, $option)
          . qq{</div>};
      } else {
        $str .= _show_all_error_html($error, $option);
      }
    }
    return $c->b($str);
  }

  sub _show_all_error_html {
    my ($error, $option) = @_;
    my $width = $option->{grid} ? 100 : 90;
    my $str = qq{
    <div id="error" class="width-${width}pc">
      <h2>ERROR!!</h2>
      <ul class="error-list">
};
    $str .= qq{<li>$_</li>\n} for $error->get_error_messages;
    $str .= qq{
      </ul>
    </div>
    };
  }

  sub _show_success_message {
    my ($c, $option) = @_;
    my $success = $c->flash('success');
    my $str = '';
    if (defined $success) {
      if ($option->{grid}) {
        $str .= qq{<div class="grid-right width-100pc">}
          . _show_success_message_html($success, $option)
          . qq{</div>};
      } else {
        $str .= _show_success_message_html($success, $option);
      }
    }
    return $c->b($str);
  }

  sub _show_success_message_html {
    my ($success, $option) = @_;
    my $width = $option->{grid} ? 100 : 90;
    my $str = qq{
      <div id="success" class="width-${width}pc">
        $success
      </div>
    };
  }

}

1;
