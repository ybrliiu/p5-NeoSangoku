package Sangoku::DB::Row::Player::CommandRecord {

  use Sangoku;
  use parent 'Sangoku::DB::Row';

  use Carp qw/croak/;

  sub rank {
    my ($self, $name, $command_records) = @_;
    my @command_records = sort { $b->execute_count <=> $a->execute_count } grep { $self->command_name eq $name } @$command_records;
    my $c_r_len = @command_records;
    my $rank = 0;
    for (my $i = 1; $i < $c_r_len; $i++) {
      $rank = $i if $command_records[$i -1]->execute_count == $command_records[$i]->execute_count;
      return $rank if $self->player_id eq $command_records[$i]->player_id;
    }
    croak 'player_id id not found.';
  }

}

1;
