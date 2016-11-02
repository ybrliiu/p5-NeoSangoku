package Sangoku::Service::Player::Mypage {

  use Mouse;
  use Sangoku;
  with 'Sangoku::Service::Role::Base';

  use Carp qw/croak/;
  use Sangoku::Util qw/validate_values/;

  sub root {
    my ($class, $player_id) = @_;

    my $config         = $class->config->{template}{player}{mypage};
    my $player         = $class->model('Player')->get($player_id);
    my $unit           = $player->unit;
    my $countreis_hash = $class->model('Country')->get_all_to_hash();
    my $country        = $player->country($countreis_hash);
    my $towns          = $class->model('Town')->get_all();
    my $towns_hash     = $class->model('Town')->to_hash($towns);
    my $town           = $player->town($towns_hash);
    my $letter = {
      player  => $player->letter($config->{letter}{player}),
      unit    => $player->unit_letter($config->{letter}{unit}),
      invite  => $player->invite($config->{letter}{invite}),
      country => $country->letter($config->{letter}{country}),
      town    => $town->letter($config->{letter}{town}),
    };

    return {
      player          => $player,
      command_log     => $player->command_log($config->{log}{command}),
      countries_hash  => $countreis_hash,
      country         => $country,
      unit            => $unit,
      towns           => $towns,
      map_data        => $class->model('Town')->get_all_for_map($towns_hash),
      town            => $player->town,
      command_list    => $class->model('Command')->get_list(),
      site            => $class->model('Site')->get(),
      map_log         => $class->model('MapLog')->get($config->{log}{map}),
      letter          => $letter,
      template_config => $config,
    };
  }

  sub write_letter {
    my ($class, $args) = @_;
    my $type = $args->{type};

    state $dispatch_method = {map { $_ => "_write_${_}_letter" } qw/player unit country town/};

    my $method = $dispatch_method->{$type};
    my $letter_data = defined $method
      ? $class->$method($args)
      : croak "不正な letter type が指定されています($type)";
    $letter_data->{type} = $type;
    return $letter_data;
  }

  sub _write_player_letter {
    my ($class, $args) = @_;
    validate_values($args => [qw/sender_id receiver_id message/]);

    my $player_model = $class->model('Player');
    my $sender   = $player_model->get($args->{sender_id});
    my $receiver = $player_model->get($args->{receiver_id});
    my $letter_data = $class->model('Player::Letter')->new(id => $sender->id)->add({
      sender   => $sender,
      receiver => $receiver,
      message  => $args->{message},
    });
    return $letter_data;
  }

  sub _write_country_letter {
    my ($class, $args) = @_;
    validate_values($args => [qw/sender_id receiver_name message/]);

    my $sender = $class->model('Player')->get($args->{sender_id});
    my $letter_data = $class->model('Country::Letter')->new(name => $sender->country_name)->add({
      sender        => $sender,
      receiver_name => $args->{receiver_name},
      message       => $args->{message},
    });
    return $letter_data;
  }

  sub _write_town_letter {
    my ($class, $args) = @_;
    validate_values($args => [qw/sender_id message/]);

    my $sender = $class->model('Player')->get($args->{sender_id});
    my $letter_data = $class->model('Town::Letter')->new(name => $sender->town_name)->add({
      sender  => $sender,
      message => $args->{message},
    });
    return $letter_data;
  }

  sub _write_unit_letter {
    my ($class, $args) = @_;
    validate_values($args => [qw/sender_id message/]);

    my $sender = $class->model('Player')->get($args->{sender_id});
    croak "部隊に所属していません" unless $sender->is_belong_unit;

    my $unit = $sender->unit;
    my $letter_model = $class->model('Unit::Letter')->new({
      id   => $unit->id,
      name => $unit->name,
    });
    my $letter_data = $letter_model->add({
      sender  => $sender,
      message => $args->{message},
    });
    return $letter_data;
  }

  __PACKAGE__->meta->make_immutable();
}

1;
