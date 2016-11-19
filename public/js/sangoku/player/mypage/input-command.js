// use jQuelly

'use strict';

(function () {
  
  sangoku.namespace('player.mypage.InputCommand');

  sangoku.player.mypage.InputCommand = function () {
    sangoku.Base.apply(this, arguments);
    this.chooseField = document.getElementById('choose-command-option');
    this.optionResult = document.getElementById('command-option-result');
  };

  sangoku.inherit(sangoku.Base, sangoku.player.mypage.InputCommand);

  var PROTOTYPE = sangoku.player.mypage.InputCommand.prototype;

  PROTOTYPE.sendOption = function (data) {
    var optionForm = document.getElementsByName(data.form_name)[0];
    var json = {
      'next_page' : data.next_page,
      'numbers' : data.numbers,
      'command_id' : data.command_id,
    };
    json[data.form_name] = optionForm.value;
    this.send('input', json);
  };

  PROTOTYPE.chooseOption = function (data) {
    var self = this;
    console.log(data);
    this.optionResult.innerHTML = data.render_html;
    document.getElementById('submit-command-option').addEventListener(self.eventType('click'), function () { self.sendOption(data); }, false);
  };

  (function () {

    var switchUrl = {
      'get' : '/player/mypage/command',
      'input' : '/player/mypage/command/input',
    };
    
    PROTOTYPE.send = function (type, json) {
      var self = this;

      $.ajax({
        url : switchUrl[type],
        cache : false,
        data : JSON.stringify(json),
        contentType : 'application/JSON',
        type : 'post',
      }).done( function(data, textStatus, jqXHR) {
        // commandのオプションを選択するとき
        if (typeof data === 'object') {
          self.chooseOption(data);
        } else {
          self.chooseField.style.display = 'none';
          document.getElementById('command-result').innerHTML = data;
        }
      }).fail( function(jqXHR, textStatus, errorThrown) {
        alert("ajax通信失敗" + "jqXHR:" + jqXHR + " textStatus:" + textStatus + " errorThrown:" + errorThrown);
      });
    };

  }());

  PROTOTYPE.inputCommand = function () {
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
    var hasOption = Number(splits[1]);
    var json = {
      'numbers' : array,
      'command_id' : commandId,
    };

    if (!hasOption) {
      this.send('input', json);
    } else {
      this.chooseField.style.display = 'block';
      json['next_page'] = 0;
      this.send('input', json);
    }
  };

  PROTOTYPE.registFunctions = function () {
    var self = this;
    // choose option window を閉じる
    this.chooseField.addEventListener(self.eventType('click'), function (eve) {
      self.chooseField.style.display = 'none';
    }, false);
    // windowが閉じないようにする
    this.optionResult.addEventListener(self.eventType('click'), function (eve) { eve.stopPropagation(); }, false);
    document.inputCommand.input.addEventListener('click', function (eve) { self.inputCommand(); }, false);
  };

}());

