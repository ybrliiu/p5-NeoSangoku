package Sangoku::Model::LoginList {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::Cache';

  use Carp qw/croak/;

  use constant KEY => 'login_list';

  sub get {
    my ($class, $player) = @_;
    croak '引数にplayerが指定されていません' unless defined $player;

    my @login_list = grep { $_->{country_name} eq $player->country_name } values %{ $class->update_login_list($player) };
    return \@login_list;
  }

  sub get_all {
    my ($class) = @_;
    return [values %{ $class->update_login_list() }];
  }

  sub update_login_list {
    my ($class, $player) = @_;

    my $time = time;
    my $login_list = $class->cache->restore($class, KEY);

    if (defined $player) {
      $login_list->{$player->id} = {
        id           => $player->id,
        country_name => $player->country_name,
        display      => $player->id . '[' . $player->town_name . '] ',
        time         => $time + 180,
      };
    }

    for my $key (keys %$login_list) {
      delete $login_list->{$key} if $login_list->{$key}{time} < $time;
    }
    $class->cache->store($class, KEY, $login_list);

    return $login_list;
  }

  __PACKAGE__->meta->make_immutable();
}

1;
