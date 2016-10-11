'use strict';

(function () {

  sangoku.namespace('player');

  sangoku.player = function () {};

  var PROTOTYPE = sangoku.player.prototype;

  PROTOTYPE.genMouseOverFunction = function (li) {
    // childNodes[1] = <ul>
    return function () { li.childNodes[1].style.display = 'block'; };
  };

  PROTOTYPE.genMouseOutFunction = function (li) {
    return function () { li.childNodes[1].style.display = 'none'; };
  };

  PROTOTYPE.registFunctionToList = function () {
    var playerMenu = document.getElementById('player-menu').childNodes;
    var playerMenuLength = playerMenu.length;
    for (var i = 3; i < playerMenuLength; i += 2) {
      var li = playerMenu[i];
      li.addEventListener('mouseover', this.genMouseOverFunction(li), false);
      li.addEventListener('mouseout', this.genMouseOutFunction(li), false);
      // without mypage link.
      if (i === 3) {
        i += 2;
      }
    }
  };

}());

