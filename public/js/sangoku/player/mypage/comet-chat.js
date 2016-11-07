'use strict';

(function () {
  
  sangoku.namespace('player.mypage.cometChat');

  var INTERVAL = 1500;

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

  sangoku.player.mypage.cometChat = function (args) {
    sangoku.base.apply(this, arguments);
    this.initChat(args);
    this.sendUri = args.sendUri;
    this.pollingUri = args.pollingUri;
    this.tryConnectLoop = false;
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

  PROTOTYPE.failFunc = function (jqXHR, textStatus, errorThrown) {
    console.log(jqXHR, textStatus, errorThrown);
    alert('サーバーと接続できませんでした。インターネットの接続を確認してください。');
    throw 'connect failed';
  };

  (function () {
  
    var failCount = 0;
    
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
  
        if (self.tryConnectLoop) { return false; }
  
        self.tryConnectLoop = true;
        var id;
        var stop = function () { clearInterval(id) };
        id = setInterval(function () {
          if (failCount >= 5) {
            stop();
            self.failFunc(jqXHR, textStatus, errorThrown);
          } else {
            self.polling();
          }
          failCount++;
        }, INTERVAL);
  
      });
    };

  }());

}());
