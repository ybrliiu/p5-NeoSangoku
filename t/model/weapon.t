use Sangoku 'test';

use Sangoku::Model::Weapon; 

my $TEST_CLASS = 'Sangoku::Model::Weapon';

subtest 'config' => sub {
  my $conf = $TEST_CLASS->config;
  ok ref $conf, 'ARRAY';
};

subtest 'to_hash' => sub {
  my $conf = $TEST_CLASS->to_hash;
  ok ref $conf, 'HASH';
};

done_testing();
