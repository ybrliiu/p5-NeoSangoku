package Record::List::CommandList {
  
  use Mouse;
  extends 'Record::List'; # 継承
  use Record;
  
  # コマンドリストデータ取得
  sub at {
    my ($self, $no) = @_;
    my $result = $self->data->[$no];
    defined $result ? $result : Record::Exception->throw("${no}番目の要素は存在してません。", $self);
  }
  
  # コマンドリストデータ更新
  sub save {
    my ($self, $no, $obj) = @_;
    $self->data->[$no] = $obj;
    return $self;
  }
  
  __PACKAGE__->meta->make_immutable();
}

1;

