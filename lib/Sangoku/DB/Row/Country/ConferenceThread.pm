package Sangoku::DB::Row::Country::ConferenceThread {

  use Mouse;
  use Sangoku;
  extends 'Sangoku::DB::Row';

  use constant {
    TITLE_LEN_MIN   => 1,
    TITLE_LEN_MAX   => 25,
    MESSAGE_LEN_MAX => 3000,
  };

  sub validate_new_thread {
    my ($self, $validator) = @_;
    $validator->check(
      title   => ['NOT_NULL', [LENGTH => (TITLE_LEN_MIN, TITLE_LEN_MAX)]],
      message => ['NOT_NULL', [LENGTH => (0, MESSAGE_LEN_MAX)]],
    );
  }

  sub replies {
    my ($self) = @_;
    my $model = $self->model('Country::ConferenceReply')->new(
      name      => $self->country_name,
      thread_id => $self->id,
    );
    return $model->get;
  }

  sub icon_path {
    my ($self) = @_;
    return $self->model('IconList')->ICONS_DIR_PATH . $self->icon . '.gif';
  }

  __PACKAGE__->meta->make_immutable();
}

1;
