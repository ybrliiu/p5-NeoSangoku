'use strict';

(function () {

  sangoku.namespace('player.mypage.webSocketChat');
  
  /* 
     args.uri = websocket url
     args.limit = {
       country : 15,
       invite  : 5,
       player  : 10,
       town    : 5,
       unit    : 5,
     }
  */

  var CONFIRM_LOOP_INTERVAL = 15000;

  sangoku.player.mypage.webSocketChat = function (args) {
    sangoku.base.apply(this, arguments);
    this.initChat(args);
    this.ws = new WebSocket(args.uri);

    var self = this;
    var ws = this.ws;
    ws.onmessage = function (eve) {
      if (eve.data === "ack") {
        console.log('ack ok.');
        return true;
      }

      var json = JSON.parse(eve.data);
      var parentDom = self[json.type];
      self.createNewLetter(parentDom, json);
      self.removeLastChild(parentDom, json.type);
    };
    ws.close = wsClose;
  };

  var wsClose = function() {
    // 接続閉じた後少し間隔を入れないとページ遷移の時にも接続閉じたことに反応する
    var count = 0;
    var timer = setInterval(function() {
      count++;
      if (count == 2) {
        clearInterval(timer);
        window.location.reload(true);
      }
    }, 1000);
  };

  var CLASS = sangoku.player.mypage.webSocketChat;

  sangoku.inherit(sangoku.base, CLASS);
  sangoku.mixin(sangoku.player.mypage.Chat, CLASS);

  var PROTOTYPE = CLASS.prototype;

  PROTOTYPE.aroundSend = function (json) { this.ws.send(JSON.stringify(json)); };

  PROTOTYPE.readyState = function () { return this.ws.readyState; };

  PROTOTYPE.startConfirmAckLoop = function () {
    var self = this;
    var msg = JSON.stringify({ping : 1});
    this.ws.send(msg);
    var count = 0;
    var id;
    var stop = function () { clearInterval(id); };
    setInterval(function () {
      self.ws.send(msg);
      count++;
    }, CONFIRM_LOOP_INTERVAL + count * 2);
  };

}());

