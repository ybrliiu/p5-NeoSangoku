package Sangoku::Model::Player::Command {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::Record';

  use Record::List::Command;
  use Sangoku::API::Player::Command;

  use constant {
    CLASS     => 'Sangoku::API::Player::Command',
    NONE_DATA => {
      id      => 'None',
      detail  => '何もしない',
      options => {},
    },
  };

  sub _build_record {
    my ($self) = @_;
    return Record::List::Command->new(
      file => CLASS->file_path($self->id),
      max  => CLASS->MAX(),
    );
  }

  sub init {
    my ($self) = @_;
    $self->record->make();
    $self->input(undef, [0 .. CLASS->MAX()-1]);
  }

  sub input {
    my ($self, $data, $numbers) = @_;
    $data //= NONE_DATA;

    my $record = $self->record();
    $record->open('LOCK_EX');
    $record->input(CLASS->new($data), $numbers);
    $record->close();
  }

  sub insert {
    my ($self, $insert_numbers, $num) = @_;
    state $none = CLASS->new(NONE_DATA);
    my $record  = $self->record();
    $record->open('LOCK_EX');
    $record->insert($none, $insert_numbers, $num);
    $record->close();
  }

  sub delete {
    my ($self, $numbers) = @_;
    state $none = CLASS->new(NONE_DATA);
    my $record  = $self->record();
    $record->open('LOCK_EX');
    $record->delete($none, $numbers);
    $record->close();
  }

  __PACKAGE__->meta->make_immutable();
}

1;
