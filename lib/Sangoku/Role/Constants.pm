package Sangoku::Role::Constants {

  use Mouse::Role;
  use Sangoku;

  # package名からそのpkg内の定数一覧を取得
  sub constants {
    my ($pkg) = @_;

    state $cache = {};
    return $cache->{$pkg} if exists $cache->{$pkg};

    no strict 'refs';
    my %table = %{"${pkg}::"};
    use strict 'refs';

    my %constants = map {
      (my $key = $_) =~ s/${pkg}:://g;
      my $value = $table{$key};
      if ($key !~ /[^A-Z0-9_]/) {

        # 定数は型グロブではなくリファレンスになっている
        if (ref $value) {
          $key => $$value;
        }
        # use constant の中に直接記述しなかった場合は型グロブになる
        elsif (defined *{$value}{CODE}) {
          $key => *{$value}{CODE}->();
        } else {
          ();
        }

      } else {
        ();
      }
    } keys %table;
    $cache->{$pkg} = \%constants;
  }

}

1;
