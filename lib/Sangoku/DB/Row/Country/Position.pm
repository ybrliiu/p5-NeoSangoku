package Sangoku::DB::Row::Country::Position {

  use Sangoku;
  use parent 'Sangoku::DB::Row';

  use Sangoku::Model::Player;

  __PACKAGE__->_generate_methods();

  sub _generate_methods {
    no strict 'refs';
    for my $method_name (qw/king premier strategist great_general
        cavalry_general guard_general archery_general infantry_general/) {

      my $_id = $method_name . '_id';
      *{$method_name} = sub {
        use strict 'refs';
        my ($self, $players_hash) = @_;
        return $self->{$method_name} if exists $self->{$method_name};
        $self->{$method_name} = ref $players_hash eq 'HASH'
          ? $players_hash->{$self->$_id // ''}
          : $self->model('Player')->get($self->$_id);
      };

      *{$method_name . '_name'} = sub {
        use strict 'refs';
        my ($self, $players_hash) = @_;
        my $player = $self->$method_name($players_hash);
        return defined $player ? $player->name : '';
      };

    }
  }

}

1;

