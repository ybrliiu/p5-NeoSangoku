package Sangoku::API::Command::Role::ChooseOption {

  use Mouse::Role;
  use Sangoku;

  use Carp qw/croak/;
  use Sangoku::Util qw/validate_values/;

  requires qw/name _build_options/;

  with 'Sangoku::API::Command::Role::Base';

  has 'has_option'     => (is => 'ro', isa => 'Int', default => 1);
  has 'options'        => (is => 'rw', isa => 'ArrayRef', builder => '_build_options');
  has 'options_length' => (is => 'rw', isa => 'Int', lazy => 1, builder => '_build_oprions_length');

  sub _build_oprions_length {
    my ($self) = @_;
    return scalar @{ $self->options };
  }

  sub input {
    my ($self, $args) = @_;
    validate_values($args => [qw/player_id numbers/, @{ $self->options }]);
    my $model = $self->model('Player::Command')->new(id => $args->{player_id});
    $model->input($self->input_data, $args->{numbers});
  }

  sub choose_option {
    my ($self, $args) = @_;
    validate_values($args => [qw/player_id current_page numbers/]);

    my $form_name = defined $self->options->[$args->{current_page}]
      ? $self->options->[$args->{current_page}]
      : croak 'オプションが存在しません。';
    my $next_page = $args->{current_page} + 1;

    return {
      command_id     => $self->id,
      numbers        => $args->{numbers},
      next_page      => $next_page,
      next_page_name => "/player/mypage/command/choose_option/@{[ lc $self->id ]}_$next_page",
      max_page       => $self->options_length,
      form_name      => $form_name,
    };
  }

}

1;

__END__

=head1 NAME
  
  Sangoku::API::Command::Role::ChooseOption
    - コマンド入力時、オプション指定をする必要があるコマンドクラスの基底ロール

=head1 DESCRIPTION
  
  package TestCommand {

    use Mouse;
    use Sangoku;

    has 'name' => (is => 'ro', isa => 'Str', default => '徴兵');

    with 'Sangoku::API::Command::Role::ChooseOption';

    # _build_options で指定する必要があるオプションを記述
    sub _build_options {
      my ($self) = @_;
      return [qw/soldier_type soldier_num/];
    }

    # さらに、template/player/mypage/command/ 以下に、オプション選択時のテンプレートを用意

  }

  1;

=cut
