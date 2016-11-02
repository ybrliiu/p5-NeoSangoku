use Sangoku 'test';

subtest 'config' => sub {

  package TestClass {

    use Mouse;
    use Sangoku 'test';
    with 'Sangoku::Role::Config';

    ok(my $config = __PACKAGE__->config('template.conf'));
    ok(my $config2 = __PACKAGE__->config('site.conf'));
    ok exists $config2->{$_} for qw/template site/;

  }

};

done_testing();
