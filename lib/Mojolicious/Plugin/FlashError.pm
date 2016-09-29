package Mojolicious::Plugin::FlashError {

  use Mojo::Base 'Mojolicious::Plugin';

  use Carp qw/croak/;
  use Module::Load;
  use Mojo::JSON qw/encode_json decode_json/;
  use Data::Structure::Util qw/unbless/;
  use HTML::FillInForm::Lite;

  has 'fill_in_form' => sub { HTML::FillInForm::Lite->new() };
  
  sub register {
    my ($self, $app, $conf) = @_;

    croak 'You need to choose validator class' unless exists $conf->{validator_class};
    my $validator_class = $conf->{validator_class};
    load $validator_class;
    croak "You need to define rebless method to $validator_class" unless $validator_class->can('rebless');
    
    $app->helper(flash_error => sub {
      my ($c, $error) = @_;

      if ($error) {
        my $json = encode_json(unbless $error);
        $c->flash(_error => $json);
      } else {
        my $json = $c->flash('_error');
        my $error = $json ? $validator_class->rebless(decode_json $json) : $validator_class->new({});
        $c->stash(error => $error);
      }

    });

  }

}

1;

__END__
