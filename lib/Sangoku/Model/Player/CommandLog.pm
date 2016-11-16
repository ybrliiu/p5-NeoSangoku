package Sangoku::Model::Player::CommandLog {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::RecordMultipleFile';

  use Record::List::Log;
  use Sangoku::API::Player::CommandLog;

  use constant CLASS => 'Sangoku::API::Player::CommandLog';

  sub _build_record {
    my ($self) = @_;
    return Record::List::Log->new(
      file => CLASS->file_path($self->id),
      max  => CLASS->MAX(),
    );
  }

  sub init {
    my ($self) = @_;
    $self->record->make();
  }

  sub add {
    my ($self, $str) = @_;
    my $log    = CLASS->new($str);
    my $record = $self->record->open('LOCK_EX');
    $record->add($log);
    $record->close();
  }

  __PACKAGE__->meta->make_immutable();
}

1;
