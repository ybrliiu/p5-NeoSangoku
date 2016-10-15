/* コマンド選択 要jQuelly */

'use strict';

(function () {

  sangoku.namespace('player.mypage.controllCommand');

  sangoku.player.mypage.controllCommand = function () {
    this.keyHit = 0;
    this.mouseHit = 0;
    this.beforeId = null;
    this.checkId = null;
  };

  var PROTOTYPE = sangoku.player.mypage.controllCommand.prototype;

  PROTOTYPE.changeUserSelect = function (type) {
    $("#can-select-command-text").toggle();
    $("#cant-select-command-text").toggle();
    $("#command td span").css("user-select", type).css("-moz-user-select", type).css("-webkit-user-select", type).css("-ms-user-select", type);
  };
  
  PROTOTYPE.addCheck = function (checkId) {
    var box = document.getElementById(checkId);
    box.style.backgroundColor = "#4682B4";
    box.style.color = "#ffffff";
    $("#command input[value=" + checkId + "]").prop('checked', true);
  };
  
  PROTOTYPE.removeCheck = function (checkId) {
    var box = document.getElementById(checkId);
    box.style.backgroundColor = "#ffffff";
    box.style.color = "#000000";
    $("#command input[value=" + checkId + "]").prop('checked', false); 
  };
  
  PROTOTYPE.pushShiftSelect = function (checkFunc) {
    if (this.keyHit) {
      if (this.checkId > this.beforeId) {
        for (var i = this.beforeId; i <= this.checkId; i++) {
          checkFunc(i);
        }
      } else {
        for (var j = this.beforeId; j >= this.checkId; j--) {
          checkFunc(j);
        }
      }
    }
  };

  PROTOTYPE.selectNumbers = function () {
    var select;
    var no = document.getElementsByName("no");
    var selectForm = document.selectCommandNumber;
    var start = Number(selectForm.start.value) - 1;
    var interval = Number(selectForm.interval.value);
    var noLength = no.length;
    for (select = 0; select < noLength; select++) {
      no[select].checked = false;
      var tr = document.getElementById(select);
      tr.style.backgroundColor = "#ffffff"; 
      tr.style.color = "#000000"; 
    }
    for (select = start; select < noLength; select += interval) {
      no[select].checked = true;
      var tr = document.getElementById(select);
      tr.style.backgroundColor = "#4682B4"; 
      tr.style.color = "#ffffff"; 
    }
  };

  PROTOTYPE.registFunctions = function () {
    var self = this;
  
    $(window).keydown(function (e) {
      if (e.keyCode === 16) { self.keyHit = 1; }
    });
    $(window).keyup(function (e) {
      if (e.keyCode === 16) { self.keyHit = 0; }
    });

    $("#command-result").on('mousedown', '#command tr', function () {
      self.checkId = Number( $(this).attr("id") );
      if (!$("#command input[value=" + self.checkId + "]").prop('checked')) {
        self.addCheck(self.checkId);
        self.pushShiftSelect(self.addCheck);
      } else {
        var box = document.getElementById(self.checkId);
        self.removeCheck(self.checkId);
        self.pushShiftSelect(self.removeCheck);
      }
      self.beforeId = self.checkId;
    });
  
    $("#command-result").on('mousedown', '#command', function () { self.mouseHit = 1; });
    $("#command-result").on('mouseup', '#command', function () { self.mouseHit = 0; });
    $("#command-result").on('mouseover', '#command tr', function () {
      if (self.mouseHit) {
        self.checkId = $(this).attr("id");
        !$("#command input[value=" + self.checkId + "]").prop('checked') ? self.addCheck(self.checkId) : self.removeCheck(self.checkId);
      }
    });
    
    document.selectCommandNumber.select.addEventListener('click', self.selectNumbers, false);

    $(document.selectCommandNumber.unCheckAll).mouseup(function () {
      $("#command input").prop('checked', false);
      $("#command tr").css("background", "#FFFFFF").css("color", "#000000");
    });
  
    $("#can-select-command-text").mouseup(function () { self.changeUserSelect("text"); });
    $("#cant-select-command-text").mouseup(function () { self.changeUserSelect("none"); });
  
  };

}());

