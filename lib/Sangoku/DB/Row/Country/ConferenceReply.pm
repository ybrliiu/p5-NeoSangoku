package Sangoku::DB::Row::Country::ConferenceReply {

  use Mouse;
  use Sangoku;
  extends 'Sangoku::DB::Row';

  use constant MESSAGE_LEN_MAX => 3000;

  # message = reply 整合性取れてないけどいいのか?
  sub validate_message {
    my ($self, $validator) = @_;
    $validator->check(
      reply => ['NOT_NULL', [LENGTH => (0, MESSAGE_LEN_MAX)]],
    );
  }

  sub icon_path {
    my ($self) = @_;
    return $self->model('IconList')->ICONS_DIR_PATH . $self->icon . '.gif';
  }

  __PACKAGE__->meta->make_immutable;
}

1;
