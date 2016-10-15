package Sangoku::API::Command::BusinessDev {

  use Mouse;
  use Sangoku;

  has 'name' => (is => 'ro', isa => 'Str', default => '商業開発');

  with 'Sangoku::API::Command::Role::Base';

  sub execute {
    my ($self, $player) = @_;
    my $town = $player->town->refetch({for_update => 1});
    $town->update({farm => $town->farm + $player->intellect});
  }

  __PACKAGE__->meta->make_immutable();
}

1;
