'use strict';

(function () {

  sangoku.namespace('sangoku.player.mypage.Chat');

  var CLASS = sangoku.player.mypage.Chat;

  CLASS.LETTERS_LEFT = ['player', 'unit', 'invite'];
  CLASS.LETTERS_RIGHT = ['country', 'town'];
  CLASS.LETTERS = CLASS.LETTERS_LEFT.concat(CLASS.LETTERS_RIGHT);
  CLASS.LETTERS_LEFT_TO_HASH = sangoku.arrayToHash(CLASS.LETTERS_LEFT);

  CLASS.initChat = function (args) {
    this.limit = args.limit;
    var self = this;
    this.LETTERS.forEach(function (element) {
      self[element] = getLetterTable(element);
    });
    this.unreadLetterNumDom = {};
  };

  var getLetterTable = function (name) {
    return document.getElementById(name + '-letter').children[0];
  };

  CLASS.createNewLetter = function (parentDom, json) {
    parentDom.insertAdjacentHTML(
      'afterbegin',
      '<tr data-letter-id="' + json.id + '"><td class="letter-icon"><img class="icon" src="/images/icons/' + json.sender_icon + '.gif"></td>'
        + '<td class="letter-message">' + json.sender_name + '@<span class="thin">' + json.sender_town_name
        + '@' + json.sender_country_name + 'から' + json.receiver_name + 'へ</span><br>『'
        + json.message + '』<br><div class="thin">' + json.time + '</div></td></tr>'
        + '<tr><td colspan="2" class="line"></td></tr>'
    );
  };

  CLASS.removeLastChild = function (parentDom, type) {
    var max = parentDom.children.length;
    if (max / 2 > this.limit[type]) {
      parentDom.removeChild(parentDom.children[max - 1]);
      parentDom.removeChild(parentDom.children[max - 2]);
    }
  };

  (function () {

     var dispatchFunction = {
       'player' : function (json, to) { json.receiver_id = to; },
       'country' : function (json, to) { json.receiver_name = to; },
       'unit' : function () {},
       'town' : function () {},
     };

     CLASS.sendLetter = function (to, message) {
       if (!message.value) { return false; }
       var json = {
         'type' : to.children[to.selectedIndex].dataset.letterType,
         'message' : message.value,
       };
       dispatchFunction[json.type](json, to.children[to.selectedIndex].value);
       this.aroundSend(json);
       message.value = '';
     };

  }());

  CLASS.aroundSend = function () {
    throw 'ロールを消費したクラスで実装する必要があります';
  };

  CLASS.registSwitchLetterBtn = function () {
    var self = this;

    Array.prototype.forEach.call(document.getElementsByClassName('letter-title-wrapper'), function (table) {
      var tdList = table.getElementsByTagName('td');

      Array.prototype.forEach.call(tdList, function (td) {
        var letterType = td.dataset.letterType;
        var table = self[letterType].parentNode;
        self.unreadLetterNumDom[letterType] = td.getElementsByTagName('span')[0];

        td.addEventListener(self.eventType('click'), function () {

          // 非表示 -> 表示
          table.style.display = 'block';
          td.id = letterType + '-letter-title';

          // 表示 -> 非表示
          var switchLetter = function (element) {
            if (letterType !== element) {
              self[element].parentNode.style.display = 'none';
            }
          };
          CLASS.LETTERS_LEFT_TO_HASH.hasOwnProperty(letterType)
            ? CLASS.LETTERS_LEFT.forEach(switchLetter)
            : CLASS.LETTERS_RIGHT.forEach(switchLetter);

          // 手紙選択タブ 表示 -> 非表示
          Array.prototype.forEach.call(tdList, function (loopTd) {
            if (td !== loopTd) { loopTd.id = loopTd.dataset.letterType + '-letter-title-empty'; }
          });

          // 未読 -> 既読
          self.unreadLetterNumDom[letterType].innerHTML = '';
          self.sendReadLetter(letterType);
        }, false);
      });
    });
  };

  CLASS.registFunctions = function () { 
    document.getElementById('letter-submit').addEventListener(this.eventType('click'), function(eve) {
      this.sendLetter(document.getElementById('letter-to'), document.getElementById('letter-message'));
    }.bind(this), false);
    this.registSwitchLetterBtn();
  };

  CLASS.isOnline = function () {
    if (navigator.onLine) {
      return true;
    } else {
      alert('インターネットに接続されていません。');
      throw 'offLine';
    }
  };

}());
