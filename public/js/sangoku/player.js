'use strict';

(function () {

  sangoku.namespace('player.Menu');

  sangoku.player.Menu = function () {
    sangoku.Base.apply(this, arguments);
  };

  sangoku.inherit(sangoku.Base, sangoku.player.Menu);

  var PROTOTYPE = sangoku.player.Menu.prototype;

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

