package Sangoku::Service::Admin::ResetGame {

  use Sangoku;

  use Sangoku::Util qw/load_child_module/;

  my @MODULES = grep {
    $_ ne 'Sangoku::Model::Site'
      && $_ ne 'Sangoku::Model::Town'
      && $_ ne 'Sangoku::Model::Country'
      && $_ !~ /Role/
  } @{ load_child_module('Sangoku::Model') };

  sub reset_game {
    my ($class, $start_time) = @_;

    Sangoku::Model::Site->init($start_time);
    Sangoku::Model::Country->init();
    Sangoku::Model::Town->init();

    for my $module (@MODULES) {
      my @is_db     = grep { $_->name =~ /Sangoku::Model::Role::DB/ } @{ $module->meta->roles };
      my @is_record = grep { $_->name =~ /Sangoku::Model::Role::Record/ } @{ $module->meta->roles };
      $module->init() if @is_db || @is_record;
    }

  }

}

1;
