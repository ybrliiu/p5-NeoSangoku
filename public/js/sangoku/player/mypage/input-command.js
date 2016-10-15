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
      var self = this;

      $.ajax({
        url : dispatchUrl[type],
        cache : false,
        data : JSON.stringify(json),
        contentType : 'application/JSON',
        type : 'post',
      }).done( function(data, textStatus, jqXHR) {

        // commandのオプションを選択するとき
        if (typeof data === 'object') {

          document.getElementById('select-command-result').innerHTML = data.render_html;
          var selectForm = document.getElementsByName(data.form_name)[0];

          document.getElementById('select-command-submit').addEventListener('click', function () {

            var json = {
              'current_page' : data.next_page,
              'numbers' : data.numbers,
              'command_id' : data.command_id,
            };
            json[data.form_name] = selectForm.value;

            if (data.max_page === data.next_page) {
              self.send('input', json);
              document.getElementById('select-command').style.display = 'none';
            } else {
              self.send('select', json);
            }
          }, false);

        } else {
          document.getElementById('command-result').innerHTML = data;
        }

      }).fail( function(jqXHR, textStatus, errorThrown) {
        alert("ajax通信失敗" + "jqXHR:" + jqXHR + " textStatus:" + textStatus + " errorThrown:" + errorThrown);
      });
    };

  }());

  PROTOTYPE.registFunctions = function () {
    var self = this;
    var selectField = document.getElementById('select-command');
    
    // close select options
    selectField.addEventListener('click', function (eve) {
      selectField.style.display = 'none';
    }, false);

    // windowが閉じないようにする
    document.getElementById('select-command-result').addEventListener('click', function (eve) {
      eve.stopPropagation();
    }, false);

    document.getElementById('submit-command').addEventListener('click', function (eve) {

      var numbers = document.getElementsByName("no");
      var numbersLength = numbers.length;

      var array = [];
      var num = 0;
      for (var i = 0 ; i < numbersLength; i++) {
        if (numbers[i].checked) {
          array[num] = numbers[i].value;
          num++;
        }
      }
      if (num === 0) { return false; }

      var selectCommand = document.forms.send.command.value;
      var splits = selectCommand.split(',');
      var commandId = splits[0];
      var selectPage = Number(splits[1]);
      var json = {
        'numbers' : array,
        'command_id' : commandId,
      };

      if (selectPage === 0) {
        self.send('input', json);
      } else {
        selectField.style.display = 'block';
        json['current_page'] = 0;
        self.send('select', json);
      }

    }, false);

  };

}());

