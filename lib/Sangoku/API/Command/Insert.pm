package Sangoku::API::Command::Insert {

  use Mouse;
  use Sangoku;

  use constant {
    INSERT_NUMBER_MIN => 1,
    INSERT_NUMBER_MAX => 24,
  };

  has 'name' => (is => 'ro', isa => 'Str', default => '空白を入れる');

  with 'Sangoku::API::Command::Role::ChooseOption';

  sub _build_options {
    my ($self) = @_;
    return ['insert_number'];
  }

  # method name is input but this module is insert command.
  sub input {
    my ($self, $args) = @_;
    my $validator = $self->validator($args);

    if ($args->{next_page} == 0) {
      return $self->_choose_last_option($validator);
    } else {
      $validator->check(
        insert_number => ['NOT_NULL', 'INT', ['BETWEEN' => (INSERT_NUMBER_MIN, INSERT_NUMBER_MAX)]]
      );

      if ($validator->has_error) {
        return $self->_choose_last_option($validator);
      } else {
        my $model = $self->model('Player::Command')->new(id => $args->{player_id});
        $model->insert($args->{numbers}, $args->{insert_number});
        return {}, $validator;
      }
    }

  }

  sub _choose_last_option {
    my ($self, $validator) = @_;
    {
      INSERT_NUMBER_MIN => INSERT_NUMBER_MIN,
      INSERT_NUMBER_MAX => INSERT_NUMBER_MAX,
    }, $validator;
  }

  __PACKAGE__->meta->make_immutable();
}

1;
