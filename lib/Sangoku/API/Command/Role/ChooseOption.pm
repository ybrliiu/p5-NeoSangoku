package Sangoku::API::Command::Role::ChooseOption {

  use Mouse::Role;
  use Sangoku;

  use Carp qw/croak/;
  use Sangoku::Util qw/validate_values/;

  requires qw/name _build_options _choose_last_option/;

  with 'Sangoku::API::Command::Role::Base';

  has 'has_option'     => (is => 'ro', isa => 'Int', default => 1);
  has 'options'        => (is => 'rw', isa => 'ArrayRef', builder => '_build_options');
  has 'options_length' => (is => 'rw', isa => 'Int', lazy => 1, builder => '_build_oprions_length');

  sub _build_oprions_length {
    my ($self) = @_;
    return scalar @{ $self->options };
  }

  around 'input' => sub {
    my ($orig, $self, $args) = @_;
    validate_values($args => [qw/player_id next_page numbers/]);

    my ($stash, $error) = $self->$orig($args);
    my $current_page = $error->has_error ? $args->{next_page} - 1 : $args->{next_page};
    my $next_page = $current_page + 1;
    my $form_name = $self->options->[$current_page];
    my $result = do {
      if ($current_page == $self->options_length && !$error->has_error) {
        +{complete => 1};
      } else {
        +{
          command_id     => $self->id,
          numbers        => $args->{numbers},
          next_page      => $next_page,
          next_page_name => "/player/mypage/command/choose_option/@{[ lc $self->id ]}_$current_page",
          form_name      => $form_name,
        };
      }
    };

    return {
      result => $result,
      stash  => $stash,
      error  => $error,
    };
  };

  sub validator {
    my ($class, $args) = @_;
    my $validator = Sangoku::Validator->new($args);
    $validator->load_default_messages();
    return $validator;
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
