'use strict';

(function () {

  sangoku.namespace('player.Menu');

  sangoku.player.Menu = function () {
    sangoku.Base.apply(this, arguments);
    this.liList = [];
  };

  sangoku.inherit(sangoku.Base, sangoku.player.Menu);

  var PROTOTYPE = sangoku.player.Menu.prototype;

  PROTOTYPE.closeMenu = function () {
    this.liList.forEach(function (li) {
      var ul = li.childNodes[1];
      if (ul.style.display === 'block') {
        li.style.backgroundColor = '';
        ul.style.display = 'none';
        this.isOpen = false;
      }
    }.bind(this));
  };

  PROTOTYPE.genFunction = function (li) {
    var ul = li.childNodes[1];
    return function (eve) {
      console.log('exec');
      eve.stopPropagation();
      this.isOpen ? this.closeMenu() : false;
      this.isOpen = true;
      li.style.backgroundColor = '#990000';
      ul.style.display = 'block'; 
    }.bind(this);
  };

  PROTOTYPE.registFunctionToList = function () {
    var playerMenu = document.getElementById('player-menu').childNodes;
    var playerMenuLength = playerMenu.length;

    for (var i = 3; i < playerMenuLength; i += 2) {
      var li = playerMenu[i];
      this.liList.push(li);
      li.addEventListener(this.eventType('click'), this.genFunction(li), false);
      // without mypage link.
      if (i === 3) { i += 2; }
    }

    window.addEventListener(this.eventType('click'), function () {
      this.isOpen ? this.closeMenu() : false;
    }.bind(this), false);
  };

}());

