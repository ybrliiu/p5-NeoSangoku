'use strict';

(function () {
  
  sangoku.namespace('player.mypage.CometChat');

  /*
    args = {
      uriOfpolling : '/player/mypage/polling',
      uriOfWriteLetter : '/player/mypage/write-letter',
      uriOfWriteReadLetterId : '/player/mypage/write-read-letter-id',
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
    this.uriOfpolling = args.uriOfpolling;
    this.uriOfWriteLetter = args.uriOfWriteLetter;
    this.uriOfWriteReadLetterId = args.uriOfWriteReadLetterId;
  };

  var CLASS = sangoku.player.mypage.CometChat;

  sangoku.inherit(sangoku.Base, CLASS);
  sangoku.mixin(sangoku.player.mypage.Chat, CLASS);

  var PROTOTYPE = CLASS.prototype;

  PROTOTYPE.sendJSON = function (args) {
    this.isOnline();
    $.ajax({
      'url' : args.uri,
      'cache' : false,
      'data' : JSON.stringify(args.json),
      'contentType' : 'application/JSON',
      'type' : 'post',
    }).done(
      args.doneFunc
    ).fail(
      args.failFunc
    );
  };

  PROTOTYPE.innerSendLetter = function (json) {
    this.sendJSON({
      'uri': this.uriOfWriteLetter,
      'json': json,
      'doneFunc' : function () {},
      'failFunc' : function () {},
    });
  };

  PROTOTYPE.innerSendReadLetterId = function (json) {
    this.sendJSON({
      'uri' : this.uriOfWriteReadLetterId,
      'json' : json,
      'doneFunc' : function () {},
      'failFunc' : function () {},
    });
  };

  PROTOTYPE.startPolling = function () {
    this.polling();
  };

  PROTOTYPE.polling = function () {
    var self = this;
    $.ajax({
      'url' : this.uriOfpolling,
      'cache' : false,
      'data' : {},
      'contentType' : 'application/JSON',
      'type' : 'post',
    }).done(function(data, textStatus, jqXHR) {
      self.receiveLetter(data);
      self.polling();
    }).fail(function(jqXHR, textStatus, errorThrown) {
      self.failFunc(jqXHR, textStatus, errorThrown);
      self.polling();
    });
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

}());
