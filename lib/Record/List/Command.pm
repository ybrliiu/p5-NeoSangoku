package Record::List::Command {
  
  use Record;
  use Mouse;
  extends 'Record::List';
  
  # コマンド入力
  sub input {
    my ($self, $input_obj, $input_list) = @_;
    my $command = $self->data;
    splice(@$command, $_, 1, $input_obj) for (@$input_list);
    $self->data($command);
    return $self;
  }
  
  # コマンド削除
  sub delete {
    my ($self, $none_obj, $delete_list) = @_;
    my @command = @{ $self->input('delete', $delete_list)->data }; # 目印つける
    @command = map { $_ eq 'delete' ? () : $_ } @command; # 目印をつけたデータを削除
    my @empty = map { $none_obj } 0 .. @$delete_list; # 空データを削除した個数分作って
    push(@command, @empty); # コマンドの配列の後ろに挿入
    $self->data(\@command);
    return $self;
  }
  
  # 空白注入
  sub insert {
    my ($self, $none_obj, $insert_list, $num) = @_;
    my %insert_list = map { $_ => 'insert' } @$insert_list; # 挿入場所をキー、insertを値とする値を作成
    my @insert = map { $none_obj } 0 .. $num-1; # 空データを挿入する個数分作る
    my @command = @{ $self->data };
    my @new_command = map { exists($insert_list{$_}) ? (@insert, $command[$_]) : $command[$_] } 0 .. $#command;
    $self->data(\@new_command);
    return $self;
  } 
  
  __PACKAGE__->meta->make_immutable();
}

1;

