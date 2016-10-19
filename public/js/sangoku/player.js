'use strict';

(function () {

  sangoku.namespace('player');

  sangoku.player = function () {
    sangoku.base.apply(this, arguments);
  };

  sangoku.inherit(sangoku.base, sangoku.player);

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

      if (this.isMobile) {
        li.addEventListener('touchstart', this.genMouseOverFunction(li), false);
      } else {
        li.addEventListener('mouseover', this.genMouseOverFunction(li), false);
      }

      li.addEventListener('mouseout', this.genMouseOutFunction(li), false);
      // without mypage link.
      if (i === 3) {
        i += 2;
      }
    }
    
  };

}());

