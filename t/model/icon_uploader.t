use Sangoku 'test';
use Test::Sangoku::PostgreSQL;

use Sangoku::Model::IconUploader;

my $TEST_CLASS = 'Sangoku::Model::IconUploader';
my $PSQL = Test::Sangoku::PostgreSQL->new();

subtest 'add&delete' => sub {

  ok $TEST_CLASS->add('動物');
  ok $TEST_CLASS->add('天子');
  ok $TEST_CLASS->add('天子');
  ok $TEST_CLASS->add('天子');
  ok $TEST_CLASS->delete(3);

};

subtest 'get' => sub {
  ok(my $list = $TEST_CLASS->get);
  is @$list, 3;
  my $icon = $list->[0];
  is $icon->tag, '天子';
};

subtest 'get_by_tag' => sub {
  ok(my $list = $TEST_CLASS->get_by_tag('動物'));
  is @$list, 1;
  my $icon = $list->[0];
  is $icon->id, 1;
};

done_testing();
