use Sangoku 'test';

subtest 'loader' => sub {

  package TestClass {
    use Mouse;
    use Sangoku 'test';
    with 'Sangoku::Role::Loader';

    ok(my $model = __PACKAGE__->model('Player'));
    is $model, 'Sangoku::Model::Player';

    ok(my $row = __PACKAGE__->row('Player'));
    is $row, 'Sangoku::DB::Row::Player';

    ok(my $api = __PACKAGE__->api('Player::Profile'));
    is $api, 'Sangoku::API::Player::Profile';
  }


};

done_testing();
