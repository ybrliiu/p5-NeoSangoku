package Sangoku::API::Role::Record {

  use Sangoku;
  use Mouse::Role;

  around 'file_path' => sub {
    my ($orig, $class, $id) = @_;

    # テストの時のファイルパス(etc/record/tmp...)
    if ($ENV{TEST_RECORD}) {
      my $regex = '\D' x length($ENV{TEST_RECORD_DIR});
      (my $file_path = $class->$orig($id)) =~ s!($regex)!$1$ENV{TEST_RECORD_TMP_DIR}/!;
      $file_path;
    } else {
      $class->$orig($id);
    }
  };

}

1;
