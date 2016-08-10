package Sangoku::Model::Player {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB';

  use Sangoku::Util qw/validate_keys load_config/;

  use constant TABLE_NAME => 'player';

  after 'init' => sub {
    my ($class) = @_;

    my $site = load_config('etc/config/site.conf')->{'site'};

    $class->regist(
      id   => $site->{admin_id},
      name => '管理人',
      pass => $site->{admin_pass},
      icon => 0,
      country_name => '無所属',
      town_name    => '開封',
      force        => 10,
      intellect    => 10,
      leadership   => 10,
      popular      => 10,
      loyalty      => 10,
      update_time  => time,
    );
  };

  sub get {
    my ($class, $id) = @_;
    $class->db->single(TABLE_NAME() => {id => $id});
  }

  sub regist {
    my ($class, %args) = @_;
    validate_keys(\%args => [qw/id name pass icon country_name town_name  force intellect leadership popular loyalty  update_time/]);

    $class->db->do_insert(TABLE_NAME() => \%args);
  }

  __PACKAGE__->meta->make_immutable();
}

1;
