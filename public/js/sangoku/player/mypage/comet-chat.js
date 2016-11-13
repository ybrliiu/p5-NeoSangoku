'use strict';

(function () {
  
  sangoku.namespace('player.mypage.CometChat');

  /*
    args = {
      sendUri : '/player/mypage/send-letter',
      pollingUri : '/player/mypage/polling',
      limit = {
        country : 15,
        invite  : 5,
        player  : 10,
        town    : 5,
        unit    : 5,
      },
    };
  */

  sangoku.player.mypage.CometChat = function (args) {
    sangoku.Base.apply(this, arguments);
    this.initChat(args);
    this.sendUri = args.sendUri;
    this.pollingUri = args.pollingUri;
  };

  var CLASS = sangoku.player.mypage.CometChat;

  sangoku.inherit(sangoku.Base, CLASS);
  sangoku.mixin(sangoku.player.mypage.Chat, CLASS);

  var PROTOTYPE = CLASS.prototype;

  PROTOTYPE.send = function (args) {
    var self = this;
    self.isOnline();
    $.ajax({
      'url' : args.uri,
      'cache' : false,
      'data' : JSON.stringify(args.json),
      'contentType' : 'application/JSON',
      'type' : 'post',
    }).done(function(data, textStatus, jqXHR) {
      args.doneFunc.call(self, data);
    }).fail(function(jqXHR, textStatus, errorThrown) {
      args.failFunc.apply(self, arguments);
    });
  };

  PROTOTYPE.aroundSend = function (json) {
    this.send({
      'uri': this.sendUri,
      'json': json,
      'doneFunc' : function () {},
      'failFunc' : function () {},
    });
  };

  PROTOTYPE.startPolling = function () {
    var self = this;
    self.polling();
  };

  PROTOTYPE.doneFunc = function (json) {
    var parentDom = this[json.type];
    this.createNewLetter(parentDom, json);
    this.removeLastChild(parentDom, json.type);
  };

  (function () {
  
    var failCount = 0;

    PROTOTYPE.failFunc = function (jqXHR, textStatus, errorThrown) {
      this.isOnline();
      if (failCount > 1) {
        alert("サーバーから切断されました。\nリロードしてください。");
        throw 'connect failed.';
        return false;
      }
      return failCount++;
    };

  }());

  PROTOTYPE.polling = function () {
    var self = this;
    $.ajax({
      'url' : this.pollingUri,
      'cache' : false,
      'data' : {},
      'contentType' : 'application/JSON',
      'type' : 'post',
    }).done(function(data, textStatus, jqXHR) {
      self.doneFunc(data);
      self.polling();
    }).fail(function(jqXHR, textStatus, errorThrown) {
      self.failFunc(jqXHR, textStatus, errorThrown);
      self.polling();
    });
  };

}());
