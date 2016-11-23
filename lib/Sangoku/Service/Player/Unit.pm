package Sangoku::Service::Player::Unit {

  use Mouse;
  use Sangoku;
  with 'Sangoku::Service::Role::Base';

  use Carp qw/croak/;
  use Sangoku::Util qw/validate_values/;

  sub root {
    my ($class, $player_id) = @_;

    my $player = $class->model('Player')->get_joined_to_country_members($player_id);
    my $players = $class->model('Player')->get_all_joined_to_unit_members();

    return {
      %{ $class->row('Unit')->constants() },
      player          => $player,
      players_hash    => $class->model('Player')->to_hash($players),
      units           => $class->model('Unit')->search(country_name => $player->country_name),
      country         => $player->country,
      countries_hash  => $class->model('Country')->get_all_to_hash,
      map_data        => $class->model('Town')->get_all_for_map,
      template_config => $class->config->{template}{player}{unit},
    };
  }

  sub break {
    my ($class, $player_id) = @_;

    my $txn = $class->txn();
    my $player = $class->model('Player')->get($player_id);
    my $unit = $class->model('Unit')->get($player->unit_id);

    croak "部隊長以外は実行できません。" unless $unit->is_leader($player);

    $class->model('Unit')->delete($unit->id);
    $txn->commit();
  }

  sub change_info {
    my ($class, $args) = @_;
    validate_values($args => [qw/player_id name message/]);

    my $validator = $class->validator($args);
    $class->row('Unit')->validate_name_and_message($validator);
    return $validator if $validator->has_error();

    {
      my $txn = $class->txn();
      my $player = $class->model('Player')->get($args->{player_id});
      my $unit = $class->model('Unit')->get($player->unit_id)->refetch({for_update => 1});
  
      croak "部隊長以外は実行できません。" unless $unit->is_leader($player);

      eval {
        $unit->update({
          name    => $args->{name},
          message => $args->{message},
        });
      };
  
      if (my $e = $@) {
        if (Sangoku::DB::Exception::Duplicate->caught($e)) {
          $validator->set_error(name => 'already_exist') if $e->reason =~ /unit_name_country_name_key/;
        }
        $txn->rollback();
      } else {
        $txn->commit();
      }
    }

    return $validator;
  }

  sub create {
    my ($class, $args) = @_;
    validate_values($args => [qw/player_id name message/]);

    my $validator = $class->validator($args);
    $class->row('Unit')->validate_name_and_message($validator);
    return $validator if $validator->has_error();

    {
      my $txn = $class->txn();
      my $player = $class->model('Player')->get($args->{player_id});
  
      eval {
        $class->model('Unit')->regist({
          leader  => $player,
          name    => $args->{name},
          message => $args->{message},
        });
      };
  
      if (my $e = $@) {
        if (Sangoku::DB::Exception::Duplicate->caught($e)) {
          $validator->set_error(name => 'already_exist') if $e->reason =~ /unit_name_country_name_key/;
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
    validate_values($args => [qw/player_id target_id/]);

    my $txn = $class->txn();

    my $leader = $class->model('Player')->get($args->{player_id});
    my $target = $class->model('Player')->get($args->{target_id});
    my $unit = $class->model('Unit')->get($leader->unit_id);

    croak "部隊長以外は実行できません。" unless $unit->is_leader($leader);
    croak "他の所属部隊の人は解雇できません" unless $leader->is_same_unit($target);
    croak "部隊長自身を解雇することはできません" if $unit->is_leader($target);

    $class->model('Unit::Members')->new(id => $unit->id)->delete($target->id);
    $txn->commit();
  }

  sub join {
    my ($class, $args) = @_;
    validate_values($args => [qw/player_id unit_id/]);

    my $player = $class->model('Player')->get($args->{player_id});
    my $unit = $class->model('Unit')->get($args->{unit_id});

    my $validator = $class->validator($args);

    $validator->set_error_and_message(unit_id => (not_select => '部隊が選択されていません。')) unless defined $unit;
    return $validator if $validator->has_error;

    $validator->set_error_and_message(unit => (cant_join => '入隊制限がかかっているので入隊できません。')) unless $unit->join_permit();
    return $validator if $validator->has_error;

    croak "他国の部隊には所属できません。" unless $unit->is_same_country($player);

    my $txn = $class->txn();
    $class->model('Unit::Members')->new(id => $unit->id)->add($player);
    $txn->commit();

    return $validator;
  }

  sub switch_join_permit {
    my ($class, $player_id) = @_;

    my $txn = $class->txn();

    my $player = $class->model('Player')->get($player_id);
    my $unit = $class->model('Unit')->get($player->unit_id)->refetch({for_update => 1});

    croak "部隊長以外は実行できません。" unless $unit->is_leader($player);

    $unit->switch_join_permit();
    $txn->commit();
  }

  sub quit {
    my ($class, $player_id) = @_;

    my $txn = $class->txn();

    my $player = $class->model('Player')->get($player_id);
    my $unit = $class->model('Unit')->get($player->unit_id);

    croak "部隊に所属していません！" unless $player->is_belong_unit();
    croak "部隊長は部隊を脱退できません。代わりに解散してください。" if $unit->is_leader($player);

    $class->model('Unit::Members')->new(id => $unit->id)->delete($player->id);
    $txn->commit();
  }

  __PACKAGE__->meta->make_immutable();
}

1;
