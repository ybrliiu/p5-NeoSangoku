use Sangoku 'test';
use Test::More;
use Test::Sangoku;
use Test::Record;

use Sangoku::Model::Site;
use Time::Piece;

my $TR = Test::Record->new();
my $TEST_CLASS = 'Sangoku::Model::Site';

subtest 'init' => sub {
  $TEST_CLASS->init('10日19時');
  ok(my $site = $TEST_CLASS->get);
  is $site->term, 0;
  is reverse_to_format($site->start_time), '10日19時';
};

subtest 'init_2' => sub {
  $TEST_CLASS->init('11日21時');
  ok(my $site = $TEST_CLASS->get);
  is $site->term, 1;
  is reverse_to_format($site->start_time), '11日21時';
};

sub reverse_to_format {
  my ($epoch_time) = @_;
  my $time = localtime($epoch_time);
  return "@{[ $time->mday ]}日@{[ $time->hour ]}時";
}

done_testing();
