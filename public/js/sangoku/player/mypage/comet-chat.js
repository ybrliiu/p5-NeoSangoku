'use strict';

(function () {
  
  sangoku.namespace('player.mypage.cometChat');

  var LETTERS = ['country', 'player', 'invite', 'unit', 'town'];
  var INTERVAL = 1500;

  /*
    args = {
      sendUri : '/player/mypage/send-letter',
      checkUri : '/player/mypage/check-new-letter',
    };
  */

  sangoku.player.mypage.cometChat = function (args) {
    sangoku.base.apply(this, arguments);
    this.sendUri = args.sendUri;
    this.checkUri = args.checkUri;
    var self = this;
    LETTERS.forEach(function (element) {
      self[element] = getLetterTable(element);
    });
  };

  sangoku.inherit(sangoku.base, sangoku.player.mypage.cometChat);

  var PROTOTYPE = sangoku.player.mypage.cometChat.prototype;

  var getLetterTable = function (name) {
    return document.getElementById(name + '-letter').children[0];
  };

  PROTOTYPE.send = function (uri, json) {
    var self = this;
    $.ajax({
      url : uri,
      cache : false,
      data : JSON.stringify(json),
      contentType : 'application/JSON',
      type : 'post',
    }).done(function(data, textStatus, jqXHR) {
      self.updateLetter(data);
    }).fail(function(jqXHR, textStatus, errorThrown) {
      console.log(jqXHR, textStatus, errorThrown);
    });
  };

  PROTOTYPE.getHeadLetterId = function (name) {
    var headRow = this[name].children[0];
    if (headRow === undefined) {
      return 0;
    }
    return headRow.dataset.letterId;
  };

  PROTOTYPE.startCheck = function () {
    var self = this;
    var timer = setInterval(function() {
      self.checkNewLetter();
    }, INTERVAL);
  };

  PROTOTYPE.checkNewLetter = function () {
    var self = this;

    var json = {};
    LETTERS.forEach(function (element) {
      json[element + '_letter_id'] = self.getHeadLetterId(element);
    });

    self.send(this.checkUri, json);
  };

  PROTOTYPE.updateLetter = function (data) {
    var self = this;
    LETTERS.forEach(function (element) {
      if (data[element]) {
        self[element].innerHTML = data[element + '_letter'];
      }
    });
  };

  (function () {

     var dispatchFunction = {
       'player' : function (json, to) { json.receiver_id = to; },
       'country' : function (json, to) { json.receiver_name = to; },
       'unit' : function () {},
       'town' : function () {},
     };

     PROTOTYPE.sendLetter = function (to, message) {
       if (!message.value) { return false; }
       var json = {
         'type' : to.children[to.selectedIndex].className,
         'message' : message.value,
       };
       dispatchFunction[json.type](json, to.children[to.selectedIndex].value);
       this.send(this.sendUri, json);
       message.value = '';
     };

  }());

  PROTOTYPE.registFunctions = function () { 
    var self = this;
    document.getElementById('letter-submit').addEventListener(self.eventType('click'), function (eve) {
      self.sendLetter(document.getElementById('letter-to'), document.getElementById('letter-message'));
    }, false);
  };

}());
