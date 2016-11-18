'use strict';

(function () {

  sangoku.namespace('player.mypage.WebSocketChat');
  
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

  var CONFIRM_LOOP_INTERVAL = 30000;

  sangoku.player.mypage.WebSocketChat = function (args) {
    sangoku.Base.apply(this, arguments);
    this.initChat(args);
    this.ws = this.newWs(args.uri);
    this.reconnectCount = 0;
    this.isSupport = true;

    window.addEventListener('beforeunload', function (e) {
      this.isSupport = false;
      this.ws.close();
      // alertではできない
      // e.preventDefault();
      // return "ページ遷移";
    }.bind(this));
  };

  var CLASS = sangoku.player.mypage.WebSocketChat;

  sangoku.inherit(sangoku.Base, CLASS);
  sangoku.mixin(sangoku.player.mypage.Chat, CLASS);

  var PROTOTYPE = CLASS.prototype;

  PROTOTYPE.newWs = function (uri) {
    var ws = new WebSocket(uri);

    ws.onmessage = function (eve) {
      if (eve.data === "ack") {
        console.log('ack.');
        return true;
      }
      var json = JSON.parse(eve.data);
      this.receiveLetter(json);
    }.bind(this);

    ws.onclose = function() {
      if (this.isSupport) {
        console.log('[ws.onclose] reconnect.');
        this.ws = this.newWs(uri);
      }
    }.bind(this);

    return ws;
  };

  PROTOTYPE.switchComet = function () {
    this.isSupport = false;
  };

  PROTOTYPE.innerSendLetter = function (json) {
    this.isOnline();
    this.ws.send(JSON.stringify(json));
  };

  PROTOTYPE.startConfirmAckLoop = function () {
    var msg = JSON.stringify({ping : 1});
    this.ws.send(msg);

    var count = 0;
    var id;
    var stop = function () { clearInterval(id); };
    id = setInterval(function () {
      this.isOnline();
      this.ws.send(msg);
      count++;
    }.bind(this), CONFIRM_LOOP_INTERVAL + count * 2);
  };

  PROTOTYPE.innerSendReadLetterId = function (json) {
    this.ws.send(JSON.stringify(json));
  };

}());

