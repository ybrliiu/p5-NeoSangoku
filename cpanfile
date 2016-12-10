requires qw/perl 5.022002/;

requires qw/Exporter 5.72/;
requires qw/Carp 1.36/
requires qw/parent 0.232/;
requires qw/constant/;
requires qw/Encode 2.72/
requires qw/Cwd 3.56_01/;
requires qw/Time::Piece 1.29/;
requires qw/Module::Load/;

requires qw/Mojolicious 7.0/;
requires qw/Mojolicious::Plugin::AssetPack 1.18/;
requires qw/Mouse 2.4.5/;
requires qw/MouseX::Foreign/;
requires qw/Class::Accessor::Lite 0.08/;
requires qw/Teng 0.28/;
requires qw/Exception::Tiny 0.2.1/;
requires qw/Cache::SharedMemoryBackend/;
requires qw/IPC::ShareLite/;

requires qw/HTML::Escape/;
requires qw/HTML::FillInForm::Lite/;
requires qw/Data::Structure::Util/;

requires qw/Path::Tiny 0.096/
requires qw/Config::PL 0.02/;

on test => sub {
  requires qw/Test::More 1.001014/;
  requires qw/Data::Dumper/;

  requires qw/Test::Exception 0.43/;
  requires qw/Test::PostgreSQL 1.20/;
  requires qw/Test::Name::FromLine 0.13/;
  requires qw/Harriet 00.05/;
  requires qw/SQL::SplitStatement 1.00020/;
  requires qw/YAML::Dumper/;
  requires qw/IO::Scalar/;
};

