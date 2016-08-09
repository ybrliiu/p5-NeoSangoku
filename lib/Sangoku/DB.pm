package Sangoku::DB {

  use Sangoku;
  use parent 'Teng';

  use Sangoku::DB::Exception;

  __PACKAGE__->load_plugin('Count');

  sub handle_error {
    my ($self, $stmt, $bind, $reason) = @_;
    $stmt =~ s/\n/\n          /gm;

    require Data::Dumper;
    local $Data::Dumper::Maxdepth = 2;

    Sangoku::DB::Exception->throw(
      message => '[Teng] An error occured from database.',
      reason  => $reason,
      sql     => $stmt,
      bind    => $bind,
    );

  }

}

1;
