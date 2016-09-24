package Sangoku::Service::Root {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Service::Role::Base';

  sub root {
    my ($class) = @_;

    my $record = $class->model('Site')->record;
    $record->open('LOCK_EX');
    my $site = $class->model('Site')->get();
    $site->access($site->access + 1);
    $record->close();

    return {
      term         => $site->term,
      access       => $site->access,
      login_people => scalar @{ $class->model('LoginList')->get_all },
      announce     => $class->model('Announce')->get(15),
      map_log      => $class->model('MapLog')->get(50),
      history_log  => $class->model('HistoryLog')->get(50),
    };
  }

  __PACKAGE__->meta->make_immutable();
}

1;
