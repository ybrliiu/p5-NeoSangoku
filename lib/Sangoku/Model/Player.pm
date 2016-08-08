package Sangoku::Model::Player {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB';

  use Sangoku::Util qw/project_root_dir/;
  use Config::PL;

  use constant TABLE_NAME => 'player';

  after 'init' => sub {
    my ($class) = @_;

    my $path = project_root_dir() . 'etc/config/site.conf';
    my $site = config_do($path)->{'site'};

    $class->db->do_insert(TABLE_NAME() => {
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
    });
  };

  sub get {
    my ($class, $id) = @_;
    $class->db->single(TABLE_NAME() => {id => $id});
  }

  __PACKAGE__->meta->make_immutable();
}

1;
