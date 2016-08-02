use Test::More;
use Jikkoku;
use Jikkoku::Util qw/child_list/;

use_ok $_ for @{ child_list('') };

done_testing;
