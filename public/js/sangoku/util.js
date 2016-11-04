'use strict';

(function () {

  sangoku.namespace('util');

  sangoku.util = function () {};
  var PROTOTYPE = sangoku.util.prototype;

  PROTOTYPE.registOpenIconList = function () {
    var btn = document.getElementById('open-icon-list');
    btn.addEventListener('click', function () {
      window.open('/outer/icon-list', 'child');
    }, false);
  };

}());
