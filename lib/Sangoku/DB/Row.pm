package Sangoku::DB::Row {

  use Sangoku;
  use parent 'Teng::Row';

  # model is method.
  use Sangoku::Util qw/model/;

  # 作成中
  sub _generate_letter_method {
    my ($class, $options) = @_;
    $options //= {};

    my $method_name = exists $options->{method_name} ? $options->{method_name} : 'letter';
    my $model_name  = $class . ucfirst $method_name;

    no strict 'refs';
    *{$class} = sub {
      use strict 'refs';
      my ($self, $limit) = @_;
      my $model = $self->model($model_name)->new();
    };
  }

}

1;
