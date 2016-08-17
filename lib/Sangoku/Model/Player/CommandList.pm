package Sangoku::Model::Player::CommandList {

  use Sangoku;
  use Mouse;

  use Carp qw/croak/;
  use Record::List::CommandList;
  use Sangoku::API::Player::CommandList;
  use Sangoku::Util qw/validate_keys/;

  use constant CLASS => 'Sangoku::API::Player::CommandList';

  has 'id'     => (is => 'ro', isa => 'Str', required => 1);
  has 'record' => (is => 'ro', isa => 'Record::List::CommandList', lazy => 1, builder => '_build_record');

  sub _build_record {
    my ($self) = @_;
    Record::List::CommandList->new(
      file => CLASS->file_path( $self->id ),
      max  => CLASS->MAX(),
    );
  }

  sub init {
    my ($self) = @_;
    $self->record->make();
    my $command_list = CLASS->new();
    my $record = $self->record->open('LOCK_EX');
    $record->save($_ => $command_list) for 0 .. CLASS->MAX() - 1;
    $record->close();
  }

  sub get {
    my ($self, $num) = @_;
    return $self->record->open->get($num);
  }

  sub get_all {
    my ($self) = @_;
    return $self->record->open->data();
  }

  sub at {
    my ($self, $no) = @_;
    my $command_list = $self->record->open->at($no);
    croak 'command data is not exists.' if $command_list->is_default_name();
    return $command_list;
  }

  sub save {
    my ($self, $no, $data) = @_;
    my $record       = $self->record->open('LOCK_EX');
    my $command_list = $record->at($no);
    $data->{name} = "保存リスト$no" if $command_list->is_default_name() && !$data->{name};
    $command_list->set($data);
    $record->save($no => $command_list);
    $record->close();
  }

  sub change_name {
    my ($self, $no, $name) = @_;
    die 'nameが指定されていません' if !$name;
    # 空データでないかチェック
    $self->at($no);
    $self->save($no => {name => $name});
  }

  sub delete {
    my ($self, $no) = @_;
    my $command_list = CLASS->new();
    my $record       = $self->record->open('LOCK_EX');
    $record->save($no => $command_list);
    $record->close();
  }

  sub remove {
    my ($self) = @_;
    $self->record->remove();
  }

  __PACKAGE__->meta->make_immutable();
}

1;
