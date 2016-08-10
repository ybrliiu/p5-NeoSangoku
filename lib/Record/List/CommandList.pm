package Record::List::CommandList {
  
  use Mouse;
  extends 'Record::List'; # 継承
  use Record;
  
  # コマンドリストデータ取得
  sub find {
    my ($self, $no) = @_;
    return $self->data->[$no];
  }
  
  # コマンドリストデータ更新
  sub update {
    my ($self, $no, $obj) = @_;
    my $data = $self->data;
    $data->[$no] = $obj;
    $self->data($data);
    return $self;
  }
  
  __PACKAGE__->meta->make_immutable();
}

1;

