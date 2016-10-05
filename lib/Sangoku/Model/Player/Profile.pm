package Sangoku::Model::Player::Profile {

  use Mouse;
  use Sangoku;
  with 'Sangoku::Model::Role::RecordSingle';

  use Record::List::Log;
  use Sangoku::API::Player::Profile;

  use constant CLASS => 'Sangoku::API::Player::Profile';

  sub init {
    my ($self) = @_;
    $self->record->make();
    my $record = $self->record->open('LOCK_EX');
    my $profile = CLASS->new();
    $record->add($profile);
    $record->close();
  }

  sub get {
    my ($self) = @_;
    my $record = $self->record->open();
    return $record->at(0);
  }

  sub edit_message {
    my ($self, $str) = @_;
    my $record = $self->record->open('LOCK_EX');
    my $site = $record->at(0);
    $site->message($str);
    $record->close();
  }

  __PACKAGE__->meta->make_immutable();
}

1;
