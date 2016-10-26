package Sangoku::Service::Player::Unit {

  use Mouse;
  use Sangoku;
  with 'Sangoku::Service::Role::Base';

  use Carp qw/croak/;
  use Sangoku::Util qw/validate_values/;

  sub root {
    my ($class, $player_id) = @_;

    my $player = $class->model('Player')->get($player_id);
    my $players = $class->model('Player')->search(country_name => $player->country_name);

    return {
      player       => $player,
      players      => $players,
      players_hash => $class->model('Player')->to_hash($players),
      units        => $class->model('Unit')->search(country_name => $player->country_name),
    };
  }

  sub break {
    my ($class, $args) = @_;
    validate_values($args => [qw/player_id unit_id/]);

    my $txn = $class->txn();
    my $player = $class->model('Player')->get($args->{player_id});
    my $unit = $class->model('Unit')->get($args->{unit_id});

    croak "部隊長以外は実行できません。" unless $unit->is_leader($player);

    $class->model('Unit')->delete($unit->id);
    $txn->commit();
  }

  sub change_info {
    my ($class, $args) = @_;
    validate_values($args => [qw/player_id unit_id message/]);

    my $validator = $class->validator($args);
    my %nfv = %{ Sangoku::DB::Row::Unit->get_all_constants() };
    $validator->check(
      message => ['NOT_NULL', [LENGTH => (0, $nfv{MESSAGE_LEN_MAX})]],
    );

    return $validator if $validator->has_error();

    {
      my $txn = $class->txn();
      my $player = $class->model('Player')->get($args->{player_id});
      my $unit = $class->model('Unit')->get($args->{unit_id})->refetch({for_update => 1});
  
      croak "部隊長以外は実行できません。" unless $unit->is_leader($player);
  
      $unit->update({message => $args->{message}});
      $txn->commit();
    }

    return $validator;
  }

  sub create {
    my ($class, $args) = @_;
    validate_values($args => [qw/player_id name message/]);

    my $validator = $class->validator($args);
    my %nfv = %{ Sangoku::DB::Row::Unit->get_all_constants() };

    $validator->check(
      name    => ['NOT_NULL', [LENGTH => ($nfv{NAME_LEN_MIN}, $nfv{NAME_LEN_MAX})]],
      message => [[LENGTH => (0, $nfv{MESSAGE_LEN_MAX})]],
    );

    return $validator if $validator->has_error();

    {
      my $txn = $class->txn();
      my $player = $class->model('Player')->get($args->{player_id})->refetch({for_update => 1});
  
      eval {
        $class->model('Unit')->create({
          leader  => $player,
          name    => $args->{name},
          message => $args->{message},
        });
        $player->update({unit_id => $player->id});
      };
  
      if (my $e = $@) {
        if ($e->caught('Sangoku::DB::Exception::Duplicate')) {
            $e->reason =~ /unit_pkey/                  ? $validator->set_error(id => 'already_exist')
          : $e->reason =~ /unit_name_country_name_key/ ? $validator->set_error(name => 'already_exist')
          : undef;
        }
        $txn->rollback();
      } else {
        $txn->commit();
      }
    }
    
    return $validator;
  }

  sub fire {
    my ($class, $args) = @_;
    validate_values($args => [qw/player_id unit_id target_id/]);

    my $txn = $class->txn();

    my $player = $class->model('Player')->get($args->{player_id});
    my $target = $class->model('Player')->get($args->{target_id})->refetch({for_update => 1});
    my $unit = $class->model('Unit')->get($args->{unit_id});

    croak "部隊長以外は実行できません。" unless $unit->is_leader($player);
    croak "ID:$args->{target_id}のプレイヤーは存在しません" unless defined $target;
    croak "他の所属部隊の人は解雇できません" unless $player->is_same_unit($target);
    croak "部隊長自身を解雇することはできません" if $unit->is_leader($player);

    $target->update({unit_id => ''});

    $txn->commit();
  }

  sub join {
    my ($class, $args) = @_;
    validate_values($args => [qw/player_id unit_id/]);

    my $txn = $class->txn();

    my $player = $class->model('Player')->get($args->{player_id})->refetch({for_update => 1});
    my $unit = $class->model('Unit')->get($args->{unit_id});

    my $validator = $class->validator($args);
    $validator->set_error_and_message(unit => (cant_join => '入隊制限がかかっているので入隊できません。')) unless $unit->join_permit();

    if ($validator->has_error) {
      $txn->rollback();
      return $validator;
    }

    croak "ID:$args->{unit_id}の部隊は存在しません" unless defined $unit;
    croak "他国の部隊には所属できません。" unless $unit->is_same_country($player);

    $player->update({unit_id => $unit->id});

    $txn->commit();
  }

  sub switch_join_permit {
    my ($class, $args) = @_;
    validate_values($args => [qw/player_id unit_id/]);

    my $txn = $class->txn();

    my $player = $class->model('Player')->get($args->{player_id});
    my $unit = $class->model('Unit')->get($args->{unit_id})->refetch({for_update => 1});

    croak "部隊長以外は実行できません。" unless $unit->is_leader($player);

    $unit->switch_join_permit();

    $txn->commit();
  }

  sub quit {
    my ($class, $player_id) = @_;

    my $txn = $class->txn();

    my $player = $class->model('Player')->get($player_id)->refetch({for_update => 1});
    my $unit = $class->model('Unit')->get($player->unit_id);

    croak "部隊に所属していません！" unless defined $unit;
    croak "部隊長は部隊を脱退できません。代わりに解散してください。" if $unit->is_leader($player);

    $player->update({unit_id => ''});

    $txn->commit();
  }

  __PACKAGE__->meta->make_immutable();
}

1;
