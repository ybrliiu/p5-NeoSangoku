package Sangoku::Model::Player::CommandList {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::Record';

  use Carp qw/croak/;
  use Record::List::CommandList;
  use Sangoku::API::Player::CommandList;

  use constant CLASS => 'Sangoku::API::Player::CommandList';

  sub _build_record {
    my ($self) = @_;
    return Record::List::CommandList->new(
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
    die 'nameが指定されていません' unless $name;
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

  __PACKAGE__->meta->make_immutable();
}

1;
