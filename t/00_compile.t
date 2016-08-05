use Sangoku 'test';
use Test::More;
use Test::Sangoku;
use Sangoku::Util qw/child_list/;

use_ok $_ for @{ child_list() };

done_testing();
