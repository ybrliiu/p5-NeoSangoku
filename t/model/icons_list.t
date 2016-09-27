use Sangoku 'test';
use Test::More;
use Test::Sangoku;

use Sangoku::Model::IconsList;
my $TEST_CLASS = 'Sangoku::Model::IconsList';

subtest 'get' => sub {
  my $dir_path = $TEST_CLASS->ICONS_DIR_PATH;
  
  my $icons_list = $TEST_CLASS->new();
  is $icons_list->max_page, '9';

  {
    ok(my $list = $icons_list->get);
    is $list->[0], "${dir_path}0.gif";
    is $list->[scalar @$list - 1], "${dir_path}49.gif";
  }

  {
    my $icons_list = $TEST_CLASS->new();
    ok(my $list = $icons_list->get(1));
    is $list->[0], "${dir_path}50.gif";
    is $list->[scalar @$list - 1], "${dir_path}99.gif";
  }

  {
    my $icons_list = $TEST_CLASS->new();
    ok(my $list = $icons_list->get(1));
    is $list->[0], "${dir_path}50.gif";
    is $list->[scalar @$list - 1], "${dir_path}99.gif";
  }

  {
    my $icons_list = $TEST_CLASS->new();
    ok(my $list = $icons_list->get(9));
    is $list->[0], "${dir_path}450.gif";
    is $list->[scalar @$list - 1], "${dir_path}499.gif";
  }

};

done_testing();
