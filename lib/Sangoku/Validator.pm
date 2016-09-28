package Sangoku::Validator {

  use Sangoku;
  use parent 'FormValidator::Lite';

  # $param をエラーにして message に $msg をセット
  sub set_error_and_message {
    my ($self, $param, $rule_name, $msg) = @_;
    $self->set_error($param => $rule_name);
    $self->set_message("$param.$rule_name" => $msg);
  }

  # エラー強調
  # <input type="text" class="<%= $error->emphasis_error() %>">
  # => <input type="text" class="field-with-error">
  sub emphasis_error {
    my ($self, $key) = @_;
    return $self->is_error($key) ? 'field-with-error' : '';
  }

  # Mojo::Validator と互換性をもたせる
  sub has_error {
    my ($self, $key) = @_;
    if (defined $key) {
      $self->is_error($key);
    } else {
      $self->SUPER::has_error();
    }
  }

}

1;

=encoding utf8

=head1 NAME
  
  Sangoku::Validator - 値検証クラス

=head1 SYNOPSIS

  # テンプレート側
  for my $msg ( $validator->get_error_messages() ) {
    <li><%= $msg %></li>
  }
  <input name="name" type="text" class="<%= $validator->emphasis_error('name') %>">
  for my $msg ( $validator->get_error_message_from_param('name') ) {
    <li>※<%= $msg %></li>
  }

=cut
