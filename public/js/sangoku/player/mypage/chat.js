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
    this.letterTbodyDom = {};
    this.LETTERS.forEach(function (element) {
      this.letterTbodyDom[element] = getLetterTable(element);
    }.bind(this));
    this.unreadLetterNumDom = {};
  };

  var getLetterTable = function (name) {
    return document.getElementById(name + '-letter').children[0];
  };

  CLASS.innerSendLetter = function () {
    throw 'innerSendLetter method を実装してください';
  };

  (function () {

     var dispatchFunction = {
       player : function (letter, to) { letter.receiver_name = to; },
       country : function (letter, to) { letter.receiver_name = to; },
       unit : function () {},
       town : function () {},
     };

     CLASS.sendLetter = function (to, message) {
       if (!message.value) { return false; }
       var option = to.getElementsByTagName('option')[to.selectedIndex];
       var letter = {
         type : option.dataset.letterType,
         message : message.value,
       };
       dispatchFunction[letter.type](letter, option.value);
       this.innerSendLetter(letter);
       message.value = '';
     };

  }());

  CLASS.createNewLetter = function (parentDom, letter) {
    parentDom.insertAdjacentHTML(
      'afterbegin',
      '<tr data-letter-id="' + letter.id + '"><td class="letter-icon"><img class="icon" src="/images/icons/' + letter.sender_icon + '.gif"></td>'
        + '<td class="letter-message">' + letter.sender_name + '@<span class="thin">' + letter.sender_town_name
        + '@' + letter.sender_country_name + 'から' + letter.receiver_name + 'へ</span><br>『'
        + letter.message + '』<br><div class="thin">' + letter.time + '</div></td></tr>'
        + '<tr><td colspan="2" class="line"></td></tr>'
    );
  };

  CLASS.removeLastChild = function (parentDom, letterType) {
    var max = parentDom.children.length;
    if (max / 2 > this.limit[letterType]) {
      parentDom.removeChild(parentDom.children[max - 1]);
      parentDom.removeChild(parentDom.children[max - 2]);
    }
  };

  CLASS.plusUnreadLetter = function (letterType) {
    var unreadLetterNumInnerHTML = this.unreadLetterNumDom[letterType].innerHTML;
    var unreadLetterNum = Number((unreadLetterNumInnerHTML.match(/\((.*?)\)/) || ['', 0])[1]) + 1;
    this.unreadLetterNumDom[letterType].innerHTML = '(' + unreadLetterNum + ')';
  };

  CLASS.receiveLetter = function (letter) {
    var parentDom = this.letterTbodyDom[letter.type];
    this.createNewLetter(parentDom, letter);
    this.removeLastChild(parentDom, letter.type);
    this.plusUnreadLetter(letter.type);
  };

  CLASS.innerSendReadLetterId = function () {
    throw 'innerSendReadLetter method を実装してください';
  };

  CLASS.sendReadLetterId = function (letterType) {
    var headLetter = this.letterTbodyDom[letterType].getElementsByTagName('tr')[0];
    if ( headLetter === undefined
      || this.unreadLetterNumDom[letterType].innerHTML === ''
    ) {
      return true;
    }

    this.unreadLetterNumDom[letterType].innerHTML = '';
    var letter = {
      type : letterType,
      id   : headLetter.dataset.letterId,
    };
    this.innerSendReadLetterId(letter);
  };

  CLASS.registSwitchLetterBtn = function () {
    var self = this;

    Array.prototype.forEach.call(document.getElementsByClassName('letter-title-wrapper'), function (table) {
      var tdList = table.getElementsByTagName('td');

      Array.prototype.forEach.call(tdList, function (td) {
        var letterType = td.dataset.letterType;
        var table = self.letterTbodyDom[letterType].parentNode;
        self.unreadLetterNumDom[letterType] = td.getElementsByTagName('span')[0];

        td.addEventListener(self.eventType('click'), function () {

          // 非表示 -> 表示
          table.style.display = 'block';
          td.id = letterType + '-letter-title';

          // 表示 -> 非表示
          var switchLetter = function (letter_type) {
            if (letterType !== letter_type) {
              self.letterTbodyDom[letter_type].parentNode.style.display = 'none';
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
          self.sendReadLetterId(letterType);
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
