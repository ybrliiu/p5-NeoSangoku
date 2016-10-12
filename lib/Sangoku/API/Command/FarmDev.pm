package Sangoku::API::Command::FarmDev {

  use Mouse;
  use Sangoku;

  has 'name' => (is => 'ro', isa => 'Str', default => '農業開発');

  with 'Sangoku::API::Command::Base';

  sub execute {
    my ($self, $player) = @_;
    my $town = $player->town->refetch({for_update => 1});
    $town->update({farm => $town->farm + $player->intellect});
  }

  __PACKAGE__->meta->make_immutable();
}

1;
