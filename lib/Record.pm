package Record 0.04 {

  use strict;
  use warnings;
  use utf8;
  use feature ':5.14';
  
  use Cwd 'getcwd';
  
  # インポート
  sub import {
    my ($class, $option) = @_;
    $option //= '';

    if($option eq 'Test'){
      $_->import for(qw/strict warnings/);
      unshift @INC, './t/lib'; # テストの時パス追加
    }
    utf8->import;
    feature->import(':5.14');

    # 自分自身をrequireしても大丈夫なのか
    require Record::Exception;
  }
  
  # project_dir
  sub project_dir {
    state $dir;
    return $dir if $dir;
    $dir = getcwd() . '/';
    $dir;
  }
  
}

1;
__END__

=encoding utf-8

=head1 NAME

Record - データ保存モジュール

=head1 SYNOPSIS

    use Record;

=head1 DESCRIPTION

Record is ...

=head1 LICENSE

Copyright (C) liiu.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

liiu E<lt>yliiu_nan-na@docomo.ne.jpE<gt>

=cut

