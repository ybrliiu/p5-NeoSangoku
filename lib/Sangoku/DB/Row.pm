package Sangoku::DB::Row {

  use Mouse;
  use Sangoku;
  use MouseX::Foreign 'Teng::Row';

  # model is method.
  use Sangoku::Util qw/model/;

  sub _generate_letter_method {
    my ($class) = @_;

    my $method_name = 'letter';
    my $model_name  = ($class =~ s/Sangoku::DB::Row:://r) . '::' . ucfirst $method_name;

    no strict 'refs';
    *{"${class}::${method_name}"} = sub {
      use strict 'refs';
      my ($self, $limit) = @_;
      my $model = $self->model($model_name)->new(name => $self->name);
      return $model->get($limit);
    };
  }

  __PACKAGE__->meta->make_immutable();
}

1;
