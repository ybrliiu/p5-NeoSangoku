package Sangoku::Model::Player::Command {

  use Sangoku;
  use Mouse;

  use Record::List::Command;
  use Sangoku::API::Player::Command;

  use constant CLASS => 'Sangoku::API::Player::Command';

  has 'id'     => (is => 'ro', isa => 'Str', required => 1);
  has 'record' => (is => 'ro', isa => 'Record::List::Command', lazy => 1, builder => '_build_record');

  our $NONE_DATA = {
    id      => 'None',
    detail  => '何もしない',
    options => {},
  };

  sub _build_record {
    my ($self) = @_;
    Record::List::Command->new(
      file => CLASS->file_path( $self->id ),
      max  => CLASS->max,
    );
  }

  sub init {
    my ($self) = @_;
    $self->record->make();
    $self->input(undef, [0 .. CLASS->max()-1]);
  }

  sub input {
    my ($self, $data, $numbers) = @_;
    $data //= $NONE_DATA;

    my $object = CLASS->new($data);

    my $record = $self->record();
    $record->open('LOCK_EX');
    $record->input($object, $numbers);
    $record->close();
  }

  sub delete {
    my ($self, $numbers) = @_;
    my $none   = CLASS->new($NONE_DATA);
    my $record = $self->record();
    $record->open('LOCK_EX');
    $record->delete($none, $numbers);
    $record->close();
  }

  sub insert {
    my ($self, $insert_numbers, $num) = @_;
    my $none   = CLASS->new($NONE_DATA);
    my $record = $self->record();
    $record->open('LOCK_EX');
    $record->insert($none, $insert_numbers, $num);
    $record->close();
  }

  sub remove {
    my ($self) = @_;
    $self->record->remove();
  }

  sub get {
    my ($self, $num) = @_;
    return $self->record->open->get($num);
  }

  sub get_all {
    my ($self) = @_;
    return $self->record->open->data();
  }

  __PACKAGE__->meta->make_immutable();
}

1;
