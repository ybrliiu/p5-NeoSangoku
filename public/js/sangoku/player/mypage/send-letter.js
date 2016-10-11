'use strict';

(function () {

  sangoku.namespace('player.mypage.sendLetter');
  
  /* 
     args.uri = websocket url
     args.playerId = <%= $player->id %>
     args.limit = {
       country : 15,
       invite  : 5,
       player  : 10,
       town    : 5,
       unit    : 5,
     }
  */

  sangoku.player.mypage.sendLetter = function (args) {
    var self = this;
    this.playerId = args.playerId;
    this.limit = args.limit;

    this.ws = new WebSocket(args.uri);
    this.ws.onmessage = function (eve) {
      var json = JSON.parse(eve.data);
      var parentDom = document.getElementById(json.type + '-letter').children[0];
      self.createNewLine(parentDom);
      self.createNewLetter(parentDom, json);
      self.removeLastChild(parentDom, json.type);
    };
    this.ws.close = function() {
      // 接続閉じた後少し間隔を入れないとページ遷移の時にも接続閉じたことに反応する
      var count = 0;
      var timer = setInterval(function() {
        count++;
        if (count == 2) {
          clearInterval(timer);
          var result = window.confirm("一定時間操作がなかったので接続が切断されました。\nリロードしますか？");
          if (result) { window.location.reload(true); }
        }
      }, 1000);
    };

  };

  var PROTOTYPE = sangoku.player.mypage.sendLetter.prototype;

  (function () {

     var dispatchFunction = {
       'player' : function (json, to) { json.receiver_id = to; },
       'country' : function (json, to) { json.receiver_name = to; },
       'unit' : function () {},
       'town' : function () {},
     };

     PROTOTYPE.send = function (to, message) {
       if (!message.value) { return false; }
       var json = {
         'type' : to.children[to.selectedIndex].className,
         'sender_id' : this.playerId,
         'message' : message.value,
       };
       dispatchFunction[json.type](json, to.children[to.selectedIndex].value);
       this.ws.send(JSON.stringify(json));
       message.value = '';
     };

  }());

  // 手紙リストの区切り要素を作成
  PROTOTYPE.createNewLine = function (parentDom) {
    var newLine = document.createElement('tr');
    newLine.innerHTML = '<td colspan="2" class="line"></td>';
    parentDom.insertBefore(newLine, parentDom.firstChild);
  };

  // 手紙追加
  PROTOTYPE.createNewLetter = function (parentDom, json) {
    var newDom = document.createElement('tr');
    newDom.innerHTML = '<td class="letter-icon"><img src="/images/icons/' + json.sender_icon + '.gif"></td>'
      + '<td class="letter-message">' + json.sender_name + '@<span class="thin">' + json.sender_town_name
      + '@' + json.receiver_name + 'から' + json.receiver_name + 'へ</span><br>『'
      + json.message + '』<br><div class="thin">' + json.time + '</div></td>';
    parentDom.insertBefore(newDom, parentDom.firstChild);
  };

  // 表示数上限を超えたDOMを削除
  PROTOTYPE.removeLastChild = function (parentDom, type) {
    var max = parentDom.children.length;
    if (max / 2 > this.limit[type]) {
      parentDom.removeChild(parentDom.children[max - 1]);
      parentDom.removeChild(parentDom.children[max - 2]);
    }
  };

  PROTOTYPE.registFunctions = function () { 
    var self = this;
    document.getElementById('letter-submit').addEventListener('click', function(eve) {
      self.send(document.getElementById('letter-to'), document.getElementById('letter-message'));
    }, false);
  };

}());

