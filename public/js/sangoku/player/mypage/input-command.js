// use jQuelly

'use strict';

(function () {
  
  sangoku.namespace('player.mypage.inputCommand');

  sangoku.player.mypage.inputCommand = function () {};

  var PROTOTYPE = sangoku.player.mypage.inputCommand.prototype;

  PROTOTYPE.send = function (json) {
    $.ajax({
      url: "/player/mypage/command",
      cache: false,
      data: JSON.stringify(json),
      contentType: 'application/JSON',
      type: 'post',
    }).done( function(data, textStatus, jqXHR) {
      document.getElementById('command-result').innerHTML = data;
    }).fail( function(jqXHR, textStatus, errorThrown) {
      alert("ajax通信失敗" + "jqXHR:" + jqXHR + " textStatus:" + textStatus + " errorThrown:" + errorThrown);
    });
  };

  PROTOTYPE.input = function (eve) {
    var e = document.getElementsByName("no");
    var array = new Array();
    var num = 0;
    for(var i = 0 ; i < e.length; i++){
      if(e[i].checked){
        array[num] = e[i].value;
        num++;
      }
    }

    var json = {
      'no' : [].concat(array), // 配列のシャローコピー
      'mode' : document.forms.send.mode.value,
    };

    this.send(json);
  };

  PROTOTYPE.registFunctions = function () {
    document.getElementById('submit-command').addEventListener('click', this.input, false);
  };

}());

