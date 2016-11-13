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

}());
