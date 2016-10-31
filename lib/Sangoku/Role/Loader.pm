package Sangoku::Role::Loader {

  use Mouse::Role;
  use Sangoku;

  __PACKAGE__->_generate_loader_method();

  sub _generate_loader_method {

    my @loader_methods = qw/model row api/;
    my %pkg_name;
    @pkg_name{@loader_methods} = qw/Model DB::Row API/;
    
    for my $method (@loader_methods) {
      no strict 'refs';
      *$method = sub {
        use strict 'refs';
        my ($class, $name) = @_;

        state $module_names = {};
        return $module_names->{$name} if exists $module_names->{$name};

        my $pkg = "Sangoku::$pkg_name{$method}::$name";
        load $pkg;
        $module_names->{$name} = $pkg;
      };
    }

  }

}

1;
