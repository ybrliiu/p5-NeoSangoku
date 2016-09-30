use Sangoku 'test';
use Sangoku::Util qw/child_module_list/;

use_ok $_ for 'Sangoku', @{ child_module_list('Sangoku') };

done_testing();
