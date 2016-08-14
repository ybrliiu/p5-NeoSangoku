use Sangoku 'test';
use Test::More;
use Test::Sangoku;
use Sangoku::Util qw/child_module_list/;

use_ok 'Sangoku';
use_ok $_ for @{ child_module_list('Sangoku') };

done_testing();
