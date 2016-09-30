use Sangoku 'test';

use Sangoku::API::Site;
my $TEST_CLASS = 'Sangoku::API::Site';

subtest 'check' => sub {
  is $TEST_CLASS->MAX(), 1;
  ok $TEST_CLASS->file_path();
};

subtest 'new' => sub {
  ok(my $site = $TEST_CLASS->new(start_time => 10000000));
  isa_ok $site, $TEST_CLASS;
};

done_testing();
