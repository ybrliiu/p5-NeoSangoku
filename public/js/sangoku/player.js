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

  PROTOTYPE.genTouchFunction = function (li) {
    var ul = li.childNodes[1];
    ul.addEventListener('touchend', function (eve) { eve.stopPropagation(); });
    var isShow = 0;
    return function () {
      if (isShow) {
        isShow = 0;
        ul.style.display = 'none'; 
      } else {
        isShow = 1;
        ul.style.display = 'block';
      }
    };
  };

  PROTOTYPE.registFunctionToList = function () {
    var playerMenu = document.getElementById('player-menu').childNodes;
    var playerMenuLength = playerMenu.length;

    for (var i = 3; i < playerMenuLength; i += 2) {
      var li = playerMenu[i];

      if (this.isMobile) {
        li.addEventListener('touchend', this.genTouchFunction(li), false);
      } else {
        li.addEventListener('mouseover', this.genMouseOverFunction(li), false);
        li.addEventListener('mouseout', this.genMouseOutFunction(li), false);
      }

      // without mypage link.
      if (i === 3) {
        i += 2;
      }
    }
    
  };

}());

