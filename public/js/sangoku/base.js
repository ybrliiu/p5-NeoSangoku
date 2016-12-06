'use strict';

(function () {

  sangoku.namespace('Base');

  sangoku.Base = function () {
    this.isMobile = this.judgeIsMobile();
  };

  var PROTOTYPE = sangoku.Base.prototype;

  PROTOTYPE.judgeIsMobile = function () {
    var ua = navigator.userAgent;
    return ua.indexOf('iPhone') > 0 || ua.indexOf('iPod') > 0 || ua.indexOf('Android') > 0;
  };

  PROTOTYPE.eventType = function (type) {
    if (this.isMobile) {
      return 'touchend';
    } else {
      return type;
    }
  };

  // sangoku.Base.prototype.sayHello.apply(this, arguments);

}());

