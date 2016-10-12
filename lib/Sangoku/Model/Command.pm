package Sangoku::Model::Command {

  use Mouse;
  use Sangoku;

  use Sangoku::Util qw/load_child_module load_config/;

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
    my ($class, $command_name) = @_;
    state $instances = {};
    return $instances->{$command_name} if exists $instances->{$command_name};
    (my $module  = "$class::$command_name") =~ s/Model/API/g;
    $instances->{$command_name} = $module->new();
  }

  sub input {
    my ($class, $command_name, $args) = @_;
    my $command = $class->_instances($command_name);
    $command->input($args);
  }

  sub select {
    my ($class, $command_name, $args) = @_;
    my $command = $class->_instances($command_name);
    $command->select($args);
  }

  sub execute {
    my ($class, $command_name, $args) = @_;
    my $command = $class->_instances($command_name);
    $command->execute($args);
  }
  
  __PACKAGE__->meta->make_immutable();
}

1;
