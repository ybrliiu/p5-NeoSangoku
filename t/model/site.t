use Sangoku 'test';
use Test::Record;

use Sangoku::Model::Site;
use Time::Piece;

my $TR = Test::Record->new();
my $TEST_CLASS = 'Sangoku::Model::Site';

subtest 'init' => sub {
  my $start_time = '2016年8月10日19時';
  $TEST_CLASS->init($start_time);
  ok(my $site = $TEST_CLASS->get);
  is $site->term, 0;
  is reverse_to_format($site->start_time), $start_time;
};

subtest 'init_2' => sub {
  my $start_time = '2016年11月20日21時';
  $TEST_CLASS->init($start_time);
  ok(my $site = $TEST_CLASS->get);
  is $site->term, 1;
  is reverse_to_format($site->start_time), $start_time;
};

sub reverse_to_format {
  my ($epoch_time) = @_;
  my $time = localtime($epoch_time);
  return "@{[ $time->year ]}年@{[ $time->mon ]}月@{[ $time->mday ]}日@{[ $time->hour ]}時";
}

done_testing();
