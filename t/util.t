use Sangoku 'test';
use Sangoku::Util;

sub test_sub {
  my ($args) = @_;
  Sangoku::Util::validate_values($args => [qw/name id/], 'something');
}

subtest 'validate_values' => sub {
  dies_ok(sub { test_sub({}) }, 'few argments');
  is($@, "somethingの キーが足りません(name, id) at t/util.t line 10\n");
  lives_ok(sub { test_sub({name => 'people', id => '7777'}) }, 'all ok');
};

subtest 'time' => sub {
  is(Sangoku::Util::datetime(1449914400), '2015/12/12(土) 19:00:00');
};

subtest 'child_module_list' => sub {
  ok(my $list = Sangoku::Util::child_module_list('Sangoku::Model::Player'));
  ok(my @exists = grep { $_ eq 'Sangoku::Model::Player::Command' } @$list);
};

done_testing();
