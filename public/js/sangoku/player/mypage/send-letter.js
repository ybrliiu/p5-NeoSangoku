'use strict';

(function () {

  sangoku.namespace('player.mypage.sendLetter');
  
  /* 
     args.uri = websocket url

     args.player = {
       name : ,
       icon : ,
       town : ,
       countryName : ,
     }

     args.limit = {
       country : 15,
       invite  : 5,
       player  : 10,
       town    : 5,
       unit    : 5,
     }

  */

  sangoku.player.mypage.sendLetter = function (args) {
    this.ws = new WebSocket(args.uri);
    this.ws.onmessage = this.receiveMessage;
    this.ws.close = this.disconnect;
    this.player = args.player;
    this.limit = args.limit;
  };

  var PROTOTYPE = sangoku.player.mypage.sendLetter.prototype;

  PROTOTYPE.receiveMessage = function (eve) {
    var json = JSON.parse(eve.data);
    var parentDom = document.getElementById(json.type + '_letter').children[0];
    this.createNewLine(parentDom);
    this.createNewLetter(parentDom, json);
    this.removeLastChild(parentDom, json.type);
  };
  
  PROTOTYPE.send = function (to, message) {
    if (!message.value) { return false; }
    var json = {
      'type' : to.children[to.selectedIndex].className,
      'from' : this.player.name,
      'icon' : this.player.icon,
      'town' : this.player.town,
      'country' : this.player.countryName,
      'to' : to.children[to.selectedIndex].value,
      'message' : message.value,
    };
    this.ws.send(JSON.stringify(json));
    message.value = '';
  };

  PROTOTYPE.disconnect = function() {
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

  // 手紙リストの区切り要素を作成
  PROTOTYPE.createNewLine = function (parentDom) {
    var newLine = document.createElement('tr');
    newLine.innerHTML = '<td colspan="2" class="line"></td>';
    parentDom.insertBefore(newLine, parentDom.firstChild);
  };

  // 手紙追加
  PROTOTYPE.createNewLetter = function (parentDom, json) {
    var newDom = document.createElement('tr');
    newDom.innerHTML = '<td class="letter_icon"><img src="/image/player_icon/' + json.icon + '.gif"></td>'
      + '<td class="letter_message">' + json.from + '@<span class="thin">' + json.town + 'から' + json.to + 'へ</span><br>『'
      + json.message + '』<br><div class="thin">' + json.datetime + '</div></td>';
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

