// use jQuelly

'use strict';

(function () {
  
  sangoku.namespace('player.mypage.inputCommand');

  sangoku.player.mypage.inputCommand = function () {};

  var PROTOTYPE = sangoku.player.mypage.inputCommand.prototype;

  PROTOTYPE.sendOption = function (data) {
    var optionForm = document.getElementsByName(data.form_name)[0];
    var json = {
      'current_page' : data.next_page,
      'numbers' : data.numbers,
      'command_id' : data.command_id,
    };
    json[data.form_name] = optionForm.value;

    if (data.max_page === data.next_page) {
      this.send('input', json);
      document.getElementById('choose-command-option').style.display = 'none';
    } else {
      this.send('chooseOption', json);
    }
  };

  PROTOTYPE.chooseOption = function (data) {
    var self = this;
    document.getElementById('command-option-result').innerHTML = data.render_html;
    document.getElementById('submit-command-option').addEventListener('click', function () { self.sendOption(data); }, false);
  };

  (function () {

    var dispatchUrl = {
      'get' : '/player/mypage/command',
      'input' : '/player/mypage/command/input',
      'chooseOption' : '/player/mypage/command/choose-option',
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
          self.chooseOption(data);
        } else {
          document.getElementById('command-result').innerHTML = data;
        }
      }).fail( function(jqXHR, textStatus, errorThrown) {
        alert("ajax通信失敗" + "jqXHR:" + jqXHR + " textStatus:" + textStatus + " errorThrown:" + errorThrown);
      });
    };

  }());

  PROTOTYPE.inputCommand = function (chooseField) {
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

    var selectCommandId = document.inputCommand.commandId.value;
    var splits = selectCommandId.split(',');
    var commandId = splits[0];
    var selectPage = Number(splits[1]);
    var json = {
      'numbers' : array,
      'command_id' : commandId,
    };

    if (selectPage === 0) {
      this.send('input', json);
    } else {
      chooseField.style.display = 'block';
      json['current_page'] = 0;
      this.send('chooseOption', json);
    }
  };

  PROTOTYPE.registFunctions = function () {
    var self = this;
    var chooseField = document.getElementById('choose-command-option');
    
    // choose option window を閉じる
    chooseField.addEventListener('click', function (eve) {
      chooseField.style.display = 'none';
    }, false);

    // windowが閉じないようにする
    document.getElementById('command-option-result').addEventListener('click', function (eve) { eve.stopPropagation(); }, false);

    document.inputCommand.input.addEventListener('click', function (eve) { self.inputCommand(chooseField); }, false);
  };

}());

