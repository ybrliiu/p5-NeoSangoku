package Sangoku::API::Role::Record {

  use Sangoku;
  use Mouse::Role;

  use constant DIR_PATH => 'etc/record/';

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

  sub get_attributes {
    my ($class) = @_;
    state $attributes;
    return $attributes if defined $attributes;

    my @list = $class->meta->get_all_attributes;
    @list = map { $_->name } @list;
    return ($attributes = \@list);
  }

}

1;
