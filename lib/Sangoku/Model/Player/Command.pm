package Sangoku::Model::Player::Command {

  use Sangoku;
  use Mouse;

  use Record::List::Command;
  use Sangoku::API::Player::Command;

  has 'id'     => (is => 'ro', isa => 'Str', required => 1);
  has 'record' => (is => 'ro', isa => 'Record::List::Command', lazy => 1, builder => '_build_record');

  sub _build_record {
    my ($self) = @_;
    my $class = 'Sangoku::API::Player::Command';
    Record::List::Command->new(
      file => $class->file_path( $self->id ),
      max  => $class->max,
    );
  }

  sub init {
    my ($self) = @_;
    $self->record->make();
    $self->record->open->data();
    $self->record->close();
  }

  sub get {
    my ($self, $num) = @_;
    $self->record->open->get($num);
  }

  sub get_all {
    my ($self) = @_;
    $self->record->open->data();
  }

  __PACKAGE__->meta->make_immutable();
}

1;
