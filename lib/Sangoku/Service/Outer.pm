package Sangoku::Service::Outer {

  use Mouse;
  use Sangoku;
  with 'Sangoku::Service::Role::Base';

  sub icon_list {
    my ($class, $page) = @_;
    $page //= 0;

    state $model = $class->model('IconList')->new();

    return {
      icons_iter     => $model->get_iter($page),
      max_page       => $model->max_page,
      current_page   => $page,
      ICONS_DIR_PATH => $model->ICONS_DIR_PATH,
    };
  }

  __PACKAGE__->meta->make_immutable();
}

1;
