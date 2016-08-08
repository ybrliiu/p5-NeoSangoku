package Sangoku 0.01 {

  use strict;
  use warnings;
  use utf8;
  use feature ':5.18';

  sub import {
    my ($class, $option) = @_;
    $option //= '';

    if ($option eq 'test') {
      unshift @INC, './t/lib'; # テストの時パス追加
    }

    $class->import_pragma;
  }
  
  # インポートするプラグマ
  sub import_pragma {
    my ($class) = @_;
    $_->import for qw/strict warnings utf8/;
    feature->import(':5.18');
  }
  
}

1;

__END__

=encoding utf8

=head1 名前
  
  Sangoku - NEO三国志NET基礎モジュール
  
=head1 メソッド
  
=head2 import
  
  モジュール読み込み時に実行されるメソッドです。
  use Sangoku;で普通にこのモジュールを読み込むと、読み込んだ側でuse strict,warnigns,utf8,feature:5.18が有効になります。
  
=cut
