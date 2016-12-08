package Sangoku::DB::Row::Country::Position {

  use Mouse;
  use Sangoku;
  extends 'Sangoku::DB::Row';

  use constant {
    POSITION_NAME => [ qw/
      君主
      宰相
      軍師
      大将軍
      騎馬将軍
      護衛将軍
      弓将軍
      将軍
    /],
  };

  sub POSITION_LIST {
    my ($self) = @_;
    state $list;
    return $list if $list;
    
    my @list = @{ $self->{table}->columns };
    shift @list;
    $list = [ map { $_ =~ s/_id//r } @list ];
  }

  sub BUILD {
    my $self = shift;
    $self->_generate_methods;
  }

  sub position_name {
    my ($self, $value) = @_;

    state $list;
    return $list->{$value} if $list;

    my %hash;
    @hash{ @{ $self->POSITION_LIST } } = @{ POSITION_NAME() };
    $list = \%hash;
    return $list->{$value};
  }

  sub _generate_methods {
    my ($self) = @_;

    state $generated;
    return 1 if $generated;

    $generated = 1;

    for my $method_name (@{ $self->POSITION_LIST }) {

      my $_id = $method_name . '_id';
      $self->meta->add_method($method_name => sub {
        my ($self, $players_hash) = @_;
        return $self->{$method_name} if exists $self->{$method_name};
        $self->{$method_name} = ref $players_hash eq 'HASH'
          ? $players_hash->{$self->$_id // ''}
          : $self->model('Player')->get($self->$_id);
      });

      $self->meta->add_method($method_name . '_name' => sub {
        my ($self, $players_hash) = @_;
        my $player = $self->$method_name($players_hash);
        return defined $player ? $player->name : '';
      });

      $self->meta->add_method($method_name . '_icon_path' => sub {
        my ($self, $players_hash) = @_;
        my $player = $self->$method_name($players_hash);
        return defined $player ? $player->icon_path : '';
      });

    }

  }

  __PACKAGE__->meta->make_immutable();
}

1;

