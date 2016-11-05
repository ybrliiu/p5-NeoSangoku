'use strict';

(function () {

  sangoku.namespace('base');

  sangoku.base = function () {
    this.isMobile = this.judgeIsMobile();
  };

  var PROTOTYPE = sangoku.base.prototype;

  PROTOTYPE.judgeIsMobile = function () {
    var ua = navigator.userAgent;
    if (
         ua.indexOf('iPhone') > 0
      || ua.indexOf('iPod') > 0
      || ua.indexOf('Android') > 0
    ) {
      return true;
    } else {
      return false;
    }
  };

  PROTOTYPE.eventType = function (type) {
    if (this.isMobile) {
      return 'touchend';
    } else {
      return type;
    }
  };

  // sangoku.base.prototype.sayHello.apply(this, arguments);

}());

