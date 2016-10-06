use Sangoku 'test';

my $TEST_CLASS = 'Sangoku::API::Player::Profile';
load $TEST_CLASS;

subtest 'check' => sub {
  ok $TEST_CLASS->MAX();
  ok $TEST_CLASS->file_path('id');
};

subtest 'new' => sub {
  ok(my $profile = $TEST_CLASS->new);
  ok $profile->message('プロフィール！！！！！');
};

done_testing();
