'use strict';

(function () {
  
  sangoku.namespace('player.mypage.cometChat');

  var INTERVAL = 1500;

  /*
    args = {
      sendUri : '/player/mypage/send-letter',
      checkUri : '/player/mypage/check-new-letter',
      limit = {
        country : 15,
        invite  : 5,
        player  : 10,
        town    : 5,
        unit    : 5,
      },
    };
  */

  sangoku.player.mypage.cometChat = function (args) {
    sangoku.base.apply(this, arguments);
    this.initChat(args);
    this.sendUri = args.sendUri;
    this.checkUri = args.checkUri;
  };

  var CLASS = sangoku.player.mypage.cometChat;

  sangoku.inherit(sangoku.base, CLASS);
  sangoku.mixin(sangoku.player.mypage.Chat, CLASS);

  var PROTOTYPE = CLASS.prototype;

  PROTOTYPE.send = function (args) {
    var self = this;
    $.ajax({
      'url' : args.uri,
      'cache' : false,
      'data' : JSON.stringify(args.json),
      'contentType' : 'application/JSON',
      'type' : 'post',
    }).done(function(data, textStatus, jqXHR) {
      args.doneFunc.call(self, data);
    }).fail(function(jqXHR, textStatus, errorThrown) {
      console.log(jqXHR, textStatus, errorThrown);
    });
  };

  PROTOTYPE.getHeadLetterId = function (name) {
    var headRow = this[name].children[0];
    if (headRow === undefined) {
      return 0;
    }
    var letterId = headRow.dataset.letterId;
    if (letterId === undefined) {
      return 0;
    }
    return letterId;
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
    PROTOTYPE.LETTERS.forEach(function (element) {
      json[element + '_letter_id'] = self.getHeadLetterId(element);
    });

    this.send({
      'uri' : this.checkUri,
      'json': json,
      'doneFunc': this.updateLetter
    });
  };

  PROTOTYPE.updateLetter = function (data) {
    var self = this;
    PROTOTYPE.LETTERS.forEach(function (element) {
      if (data[element]) {
        self[element].innerHTML = data[element + '_letter'];
      }
    });
  };

  PROTOTYPE.doneSend = function (json) {
    var parentDom = this[json.type];
    this.createNewLetter(parentDom, json);
    this.removeLastChild(parentDom, json.type);
  };

  PROTOTYPE.aroundSend = function (json) {
    this.send({
      'uri': this.sendUri,
      'json': json,
      'doneFunc' : this.doneSend,
    });
  };

}());
