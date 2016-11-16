package Sangoku::Model::Role::RecordMultipleFile {

  use Mouse::Role;
  use Sangoku;
  with 'Sangoku::Model::Role::Record';
  requires qw/_build_record init/;

  use Path::Tiny;

  has 'id'     => (is => 'ro', isa => 'Str', required => 1);
  has 'record' => (is => 'ro', lazy => 1, builder => '_build_record');

  sub get {
    my ($self, $num) = @_;
    return $self->record->open->get($num);
  }

  sub get_all {
    my ($self) = @_;
    return $self->record->open->data();
  }

  sub remove {
    my ($self) = @_;
    $self->record->remove();
  }

  sub remove_all {
    my ($class) = @_;
    (my $dir = $class->CLASS->file_path('')) =~ s/\.dat//g;
    my $iter = path($dir)->iterator();
    while (my $path = $iter->()) {
      $path->remove() if $path =~ /\.dat$/;
    }
  }

}

1;
