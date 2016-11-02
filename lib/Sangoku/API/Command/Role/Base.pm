package Sangoku::API::Command::Role::Base {

  use Mouse::Role;
  use Sangoku;
  with map { "Sangoku::Role::$_" } qw/Constants Loader/;

  # model is model loader method.
  use Sangoku::Util qw/validate_values/;
  use Sangoku::Validator;
  use Carp qw/croak/;

  # name => attr
  requires qw/name/;

  has 'id'         => (is => 'ro', isa => 'Str', builder => '_build_id');
  has 'has_option' => (is => 'ro', isa => 'Int', default => 0);
  has 'input_data' => (is => 'rw', isa => 'HashRef', lazy => 1, builder => '_build_input_data');

  sub _build_id {
    my ($self) = @_;
    # 正規表現で id を class から取り出し
    (my $id = ref $self) =~ s/(.*)(?=::)|:://g;
    return $id;
  }

  sub _build_input_data {
    my ($self) = @_;
    return {
      id      => $self->id,
      detail  => $self->name,
      options => {},
    };
  }

  sub input {
    my ($self, $args) = @_;
    validate_values($args => [qw/player_id numbers/]);
    my $model = $self->model('Player::Command')->new(id => $args->{player_id});
    $model->input($self->input_data, $args->{numbers});
  }

  sub execute {
    my ($self) = @_;
    croak $self->name . 'コマンドは execute method を実行できません。...もしくは実装されていません。';
  }

  sub permit {
    my ($self) = @_;
    return 1;
  }

}

1;

__END__

=encoding utf8

=head1 NAME
  
  Sangoku::Model::Command::Base - command クラス基底ロール

=head1 ATTRIBUTE

=head2 id

コマンドのidです。
クラス名からSangoku::Model::Commandを取り除いたもので、
コマンド入力や実行時の識別時に使用します。

=head2 has_option 

コマンド入力の時に追加の情報を付加するかどうか。
この値が正値になる場合は ChooseOption ロールを取り込む場合のみです。

=cut

