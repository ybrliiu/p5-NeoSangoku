package Sangoku::DB::Row {

  use Mouse;
  use Sangoku;
  use MouseX::Foreign 'Teng::Row';
  with map { "Sangoku::Role::$_" } qw/Constants Config Loader/;

  sub _generate_letter_model_method {
    my ($class) = @_;

    my $method_name = 'letter_model';
    my $model_name  = ($class =~ s/Sangoku::DB::Row:://r) . '::' . (ucfirst $method_name =~ s/_model//r);

    no strict 'refs';
    *{"${class}::${method_name}"} = sub {
      use strict 'refs';
      my ($self) = @_;
      return $self->model($model_name)->new(name => $self->name);
    };
  }

  __PACKAGE__->meta->make_immutable();
}

1;
