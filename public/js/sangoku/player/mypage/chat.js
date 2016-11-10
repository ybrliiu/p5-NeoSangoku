'use strict';

(function () {

  sangoku.namespace('sangoku.player.mypage.Chat');

  var CLASS = sangoku.player.mypage.Chat;

  CLASS.LETTERS = ['country', 'player', 'invite', 'unit', 'town'];

  CLASS.initChat = function (args) {
    this.limit = args.limit;

    var self = this;
    this.LETTERS.forEach(function (element) {
      self[element] = getLetterTable(element);
    });
  };

  var getLetterTable = function (name) {
    return document.getElementById(name + '-letter').children[0];
  };

  CLASS.createNewLetter = function (parentDom, json) {
    parentDom.insertAdjacentHTML(
      'afterbegin',
      '<td class="letter-icon"><img class="icon" src="/images/icons/' + json.sender_icon + '.gif"></td>'
        + '<td class="letter-message">' + json.sender_name + '@<span class="thin">' + json.sender_town_name
        + '@' + json.sender_country_name + 'から' + json.receiver_name + 'へ</span><br>『'
        + json.message + '』<br><div class="thin">' + json.time + '</div></td>'
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
         'type' : to.children[to.selectedIndex].className,
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

  CLASS.registFunctions = function () { 
    var self = this;
    document.getElementById('letter-submit').addEventListener(self.eventType('click'), function(eve) {
      self.sendLetter(document.getElementById('letter-to'), document.getElementById('letter-message'));
    }, false);
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
