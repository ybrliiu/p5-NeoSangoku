package Sangoku::Model::Command {

  use Mouse;
  use Sangoku;

  use Sangoku::Util qw/load_child_module load_config load validate_values/;

  sub get_list {
    my ($class) = @_;
    state $command_list;
    return $command_list if $command_list;

    my %commands = map {
      # my $module = Sangoku::API::Command::$_
      (my $module  = $_) =~ s/Model/API/g;
      my $command = $module->new();
      $command->id => $command;
    } @{ load_child_module('Sangoku::API::Command') };
    
    $command_list = $class->_sort_command_list(\%commands);
    return $command_list;
  }

  sub _sort_command_list {
    my ($class, $commands) = @_;
    my $list = load_config('data/command_order.conf');
    my @command_list = map { exists($commands->{$_}) ? $commands->{$_} : $_ } @{ $list->{command_order} };
    return \@command_list;
  }

  sub _instances {
    my ($class, $command_id) = @_;
    state $instances = {};
    return $instances->{$command_id} if exists $instances->{$command_id};
    (my $module  = "$class::$command_id") =~ s/Model/API/g;
    load $module;
    $instances->{$command_id} = $module->new();
  }

  sub input {
    my ($class, $args) = @_;
    validate_values($args => [qw/player_id command_id/]);
    my $command = $class->_instances($args->{command_id});
    $command->input($args);
  }

  sub select {
    my ($class, $args) = @_;
    validate_values($args => [qw/player_id command_id/]);
    my $command = $class->_instances($args->{command_id});
    $command->select($args);
  }

  sub execute {
    my ($class, $command_id, $args) = @_;
    my $command = $class->_instances($command_id);
    $command->execute($args);
  }
  
  __PACKAGE__->meta->make_immutable();
}

1;
