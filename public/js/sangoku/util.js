'use strict';

(function () {

  sangoku.namespace('Util');

  sangoku.Util = function () {
    sangoku.Base.apply(this, arguments);
  };

  sangoku.inherit(sangoku.Base, sangoku.Util);

  var PROTOTYPE = sangoku.Util.prototype;

  PROTOTYPE.registOpenIconList = function () {
    var btn = document.getElementById('open-icon-list');
    btn.addEventListener(this.eventType('click'), function () {
      window.open('/outer/icon-list', 'child');
    }, false);
  };

  PROTOTYPE.navigator = function () {

    var upArrow = document.getElementById('up-arrow');
    if (upArrow !== null) {
      upArrow.parentNode.addEventListener('click', function () {
        window.scrollTo(0, 0);
      });
    }
  
    var downArrow = document.getElementById('down-arrow');
    if (downArrow !== null) {
      var height = document.getElementsByTagName('html')[0].scrollHeight;
      downArrow.parentNode.addEventListener('click', function () {
        console.log( height );
        window.scrollTo(0, height);
      });
    }

  };

}());
