use Sangoku 'test';

subtest 'constants' => sub {

  package TestClass {

    use Mouse;
    use Sangoku;
    with 'Sangoku::Role::Constants';

    use constant {
      MAX     => 100,
      MIN     => 10,
      KEYWORD => '!?!?!?',
    };

  };

  ok(my $constants = TestClass->constants);
  is $constants->{MAX}, TestClass->MAX;
  is $constants->{MIN}, TestClass->MIN;
  is $constants->{KEYWORD}, TestClass->KEYWORD;

  # fix bug if constant is not refarence
  my $buged_class = 'Sangoku::DB::Row::Country';
  load $buged_class;
  ok($constants = $buged_class->constants);
  is $constants->{NAME_LEN_MIN}, $buged_class->NAME_LEN_MIN;

};

done_testing();
