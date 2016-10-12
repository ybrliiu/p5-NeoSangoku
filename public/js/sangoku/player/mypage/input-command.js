// use jQuelly

'use strict';

(function () {
  
  sangoku.namespace('player.mypage.inputCommand');

  sangoku.player.mypage.inputCommand = function () {};

  var PROTOTYPE = sangoku.player.mypage.inputCommand.prototype;

  (function () {

    var dispatchUrl = {
      'get' : '/player/mypage/command',
      'input' : '/player/mypage/command/input',
      'select' : '/player/mypage/command/select',
    };
    
    PROTOTYPE.send = function (type, json) {
      $.ajax({
        url : dispatchUrl[type],
        cache : false,
        data : JSON.stringify(json),
        contentType : 'application/JSON',
        type : 'post',
      }).done( function(data, textStatus, jqXHR) {
        document.getElementById('command-result').innerHTML = data;
      }).fail( function(jqXHR, textStatus, errorThrown) {
        alert("ajax通信失敗" + "jqXHR:" + jqXHR + " textStatus:" + textStatus + " errorThrown:" + errorThrown);
      });
    };

  }());

  PROTOTYPE.registFunctions = function () {
    var self = this;
    document.getElementById('submit-command').addEventListener('click', function (eve) {

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
        'numbers' : [].concat(array),
        'command_name' : document.forms.send.mode.value,
      };
  
      self.send('input', json);
    }, false);
  };

}());

