package Mojolicious::Plugin::FlashError {

  use Mojo::Base 'Mojolicious::Plugin';

  use Carp qw/croak/;
  use Module::Load;
  use Mojo::JSON qw/encode_json decode_json/;
  use Data::Structure::Util qw/unbless/;
  use HTML::FillInForm::Lite;

  sub register {
    my ($self, $app, $conf) = @_;

    croak 'You need to choose validator class' unless exists $conf->{validator_class};
    my $validator_class = $conf->{validator_class};
    load $validator_class;
    croak "You need to define rebless method to $validator_class" unless $validator_class->can('rebless');
    
    # flash に json でエラーオブジェクトを保存
    $app->helper(flash_error => sub {
      my ($c, $error) = @_;

      if ($error) {
        my $json = encode_json(unbless $error);
        $c->flash(_error => $json);
      } else {
        my $json = $c->flash('_error');
        my $error = $json ? $validator_class->rebless(decode_json $json) : $validator_class->new($c);
        $c->stash(error => $error);
      }

    });

    # flash に validator情報を格納した場合、フォームの値の充填は行われないので
    # FillInForm::Lite で行う
    my $fill_in_form = HTML::FillInForm::Lite->new(fill_password => 1);
  
    $app->helper(render_fill_error => sub {
      my ($c, $file) = @_;
      $file //= '';
      my $html = $c->render_to_string();
      my $error = $c->stash->{error};
      my $fill = $fill_in_form->fill(\$html, $error);
      $c->render(text => $fill);
    });

  }

}

1;

__END__
