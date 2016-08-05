use Jikkoku 'test';
use Test::More;
use Test::Jikkoku;
use Test::Exception;

use Jikkoku::Util;

sub test_sub {
  my ($args) = @_;
  Jikkoku::Util::validate_keys($args => [qw/name id/], 'something');
}

subtest 'validate_keys' => sub {
  dies_ok(sub { test_sub({}) }, 'few argments');
  is($@, "somethingの キーが足りません(name, id) at t/util.t line 14\n");
  lives_ok(sub { test_sub({name => 'people', id => '7777'}) }, 'all ok');
};

subtest 'time' => sub {
  is(Jikkoku::Util::datetime(1449914400), '2015/12/12(土) 19:00:00');
};

subtest 'child_list' => sub {
  ok(my $list = Jikkoku::Util::child_list('Jikkoku::DB'));
  ok(my @exists = grep { $_ eq 'Jikkoku::DB::Schema' } @$list);
};

done_testing();
