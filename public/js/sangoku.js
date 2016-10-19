/* root namespace */

'use strict';

var sangoku = sangoku || {};

// なぜかnameSpaceだと上手く行かない...(予約語？)
sangoku.namespace = function (pkgName) {

  var parts = pkgName.split('.');
  var parent = sangoku;

  if (parts[0] === 'sangoku') {
    parts = parts.slice(1);
  }

  for (var i = 0; i < parts.length; i++) {
    if (typeof parent[parts[i]] === "undefined") {
      parent[parts[i]] = {};
    }
    parent = parent[parts[i]];
  }

};

sangoku.inherit = function (base, child) {
  child.prototype = Object.create(base.prototype);
  child.prototype.constructor = child;
};

