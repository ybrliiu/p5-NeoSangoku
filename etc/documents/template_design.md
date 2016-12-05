# htmlの基本構成(Nカラム)
``` html
<div id="wrapper">
  <div id="inner_around">見出しなど</div>
  <!-- 2カラムレイアウト -->
  <div class="inner">
    左側
  </div>
  <div class="inner_right">
    右側
  <div>
  <!-- 3カラムレイアウト-->
  <div class="inner">
    左側
  </div>
  <div class="inner">
    中央
  </div>
  <div class="inner_right">
    右側
  <div>
</div>
```

# htmlの基本構成(中央寄せタイプ)
``` html
<div id="wrapper">
  <div class="centering">
    <div>
      中央
    </div>
    <table class="table-tile">
      <tr><th></th></tr>
      <tr><td></td></td>
    </table>
  </div>
</div>
```

# 外部 SCSSファイルの読み込みについて
* Web.pm の assets plugin load のところに追記
* template %layout 'player' => (SCSS_FILES => ['player/mypage.css']);
* 上記の記述で header 内で scss ファイルが読み込まれるようになる
* 継承元や継承先の template で CSS_FILES を上書きしてしまうと消えてしまうので注意

# 外部 JSファイルの読み込みについて
* (先頭) にpush @$JS_FILES, ('file1', ...);
* 親テンプレートで読み込む際は、 unshift
* 上記の記述で body の最後でJSファイルを読み込む
* 当然、bodyの最後で読み込んだJSファイルを使用する埋め込みスクリプトは window.addEventlistener('load' ...)
  で記述しなければならない
* SCSSファイルと同様の追加方法も使用できるが、継承元や継承先で読みこませようとした JSファイルが読み込まれなくなるので注意(変数の上書き)

