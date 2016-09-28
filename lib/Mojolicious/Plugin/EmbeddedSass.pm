package Mojolicious::Plugin::EmbeddedSass {

  use Mojo::Base 'Mojolicious::Plugin';
  
  use Mojo::Cache;
  use CSS::Sass;
  
  has 'sass'  => sub { CSS::Sass->new( output_style => CSS::Sass::SASS_STYLE_EXPANDED() ); };
  has 'cache' => sub { Mojo::Cache->new(max_keys => 200); };
  
  sub register {
    my ($self, $app, $conf) = @_;
    
    $app->helper(scss_to_css => sub {
      my ($c, $scss, $conf) = @_;
      my $route = $c->current_route();
      my $cache = $self->cache->get($route);
      if ($cache) {
        $app->log->debug('Loading cached scss data...');
        return $cache;
      }else{
        my $compile = $self->sass->compile($$scss);
        $self->cache->set($route => $compile) if $conf;
        return $compile;
      }
    });
  }

}

1;

__END__

=encoding utf8

=head1 名前

Mojolicious::Plugin::EmbeddedSass - Mojoliciousのテンプレートで直接SCSSが書けるプラグイン

=head1 使用法
  
  # Mojolicious lib/Myapp.pmで
  $self->plugin('EmbeddedSass'); # テンプレートでSassを直接書くためのプラグインをロード
  
  # Mojolicious::Lite
  plugin 'EmbeddedSass';
  
  # テンプレート内で使用する
  %= stylesheet begin
  <% my $scss = ' # scssを変数に格納
    
  $red:'.$config->{'color'}{'red'}.';  
    
  .red {  
    color: $red;  
  }  
    
  '; %>
  %== scss_to_css($scss,1); #scssをcssに変換、キャッシュする、返却値はXMLエスケープせずに出力
  %= end

=head1 ヘルパー

=head2 scss_to_css($scss,$cache)
  
  %== scss_to_css($scss,0);
    scssで書かれたデータをcssにコンパイルします。
    返却値にcssにコンパイルされたコードが格納されますが、Mojo::ByteStreamオブジェクトにしていないのでXMLエスケープはされていません。
    第1引数にはscssで書かれたデータをわたしてください。
    第2引数に1を渡すとキャッシュ、0を渡すとキャッシュしません。
    キャッシュしないとscssのコード内容にもよりますが速度が落ちてしまいます。
    また、scssのコードが多い場合はキャッシュせずにテンプレートと分離して外部ファイルとして書きだし、その上でMojolicious::Plugin::AssetPackなどでコンパイルするようにした方がよいでしょう。

=head1 See also
  
  CSS::Sass - これの本体
  Mojolicious::Plugin::AssetPack - Sassを別のファイルとして書いている場合はこちらを使用
  Mojolicious::Plugin::Sass - 似たようなモジュール？
  Mojolicious::Plugin::SassRenderer - 似たようなモジュール？
  Text::Sass - 別のperlのsassコンパイラ、未完成
  
=cut
