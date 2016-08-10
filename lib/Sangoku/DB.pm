package Sangoku::DB {

  use Sangoku;
  use parent 'Teng';

  use Sangoku::DB::Exception;
  use Sangoku::DB::Exception::Duplicate;

  __PACKAGE__->load_plugin('Count');

  sub handle_error {
    my ($self, $stmt, $bind, $reason) = @_;
    $stmt =~ s/\n/\n          /gm;

    if ($reason =~ /DBD::Pg::st execute failed: ERROR:  duplicate key value/) {
      Sangoku::DB::Exception::Duplicate->throw(
        message => '[Teng] A duplicate error occured from database.',
        reason  => $reason,
        sql     => $stmt,
        bind    => $bind,
      );
    } else {
      Sangoku::DB::Exception->throw(
        message => '[Teng] An error occured from database.',
        reason  => $reason,
        sql     => $stmt,
        bind    => $bind,
      );
    }

  }

}

1;
