package Sangoku::Service::Outer::Regist {

  use Mouse;
  use Sangoku;
  with 'Sangoku::Service::Role::Base';

  sub root {
    my ($class) = @_;

    my $towns = $class->model('Town')->get_all();

    return {
      towns => $towns,
    };
  }

}

1;
