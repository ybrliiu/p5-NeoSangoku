'use strict';

(function () {

  sangoku.namespace('sangoku.Sortable');

  var NUMBER_CLASS = 'sort-by-number';
  var STRING_CLASS = 'sort-by-string';
  var DATA_CLASS = 'sort-by-data';

  var ASC_CLASS = 'sorted-asc';
  var DESC_CLASS = 'sorted-desc';

  sangoku.Sortable = function () {
    sangoku.Base.apply(this, arguments);
    this.beforeTable = undefined;
    this.beforeTh = undefined;
  };

  var CLASS = sangoku.Sortable;

  sangoku.inherit(sangoku.Base, CLASS);

  var PROTOTYPE = CLASS.prototype;

  PROTOTYPE.switchOrderClass = function (th) {
    if (th.classList.contains(ASC_CLASS)) {
      th.classList.remove(ASC_CLASS);
      th.classList.add(DESC_CLASS);
    } else {
      th.classList.remove(DESC_CLASS);
      th.classList.add(ASC_CLASS);
    }
  };

  PROTOTYPE.addOrderClass = function (table, th) {
    if (
      this.beforeTh !== undefined &&
      this.beforeTable === table
    ) {
      this.beforeTh.classList.remove(ASC_CLASS);
      this.beforeTh.classList.remove(DESC_CLASS);
    } else if (
      this.beforeTable !== undefined &&
      this.beforeTable !== table
    ) {
      var asc = table.getElementsByClassName(ASC_CLASS)[0];
      if (asc !== undefined) {
        if (asc !== th) { asc.classList.remove(ASC_CLASS); }
      }
      var desc = table.getElementsByClassName(DESC_CLASS)[0];
      if (desc !== undefined) {
        if (desc !== th) { desc.classList.remove(DESC_CLASS); }
      }
    }
    this.switchOrderClass(th);
  };

  PROTOTYPE.setSortedColumn = function (table, th) {
    this.beforeTh === th ? this.switchOrderClass(th) : this.addOrderClass(table, th);
    this.beforeTh = th;
    this.beforeTable = table;
  };

  (function () {

    var replaceRows = function (table, rows) {
      var tbody = table.getElementsByTagName('tbody')[0];
      var headRow = tbody.getElementsByTagName('tr')[0];
  
      var newTbody = document.createElement('tbody');
      newTbody.appendChild(headRow);
      rows.forEach(function (tr) {
        newTbody.appendChild(tr);
      });
      table.replaceChild(newTbody, tbody);
    };
  
    var compareColumnNumber = function (a, b, columnIndex) {
      var numA = Number(a.getElementsByTagName('td')[columnIndex].innerHTML);
      var numB = Number(b.getElementsByTagName('td')[columnIndex].innerHTML);
      return (numB > numA) ? 1 : (numB < numA) ? -1 : 0;
    };
  
    var compareColumnString = function (a, b, columnIndex) {
      var numA = a.getElementsByTagName('td')[columnIndex].innerHTML;
      var numB = b.getElementsByTagName('td')[columnIndex].innerHTML;
      return (numB > numA) ? 1 : (numB < numA) ? -1 : 0;
    };
  
    var compareColumnData = function (a, b, columnIndex) {
      var numA = Number(a.getElementsByTagName('td')[columnIndex].dataset.compare);
      var numB = Number(b.getElementsByTagName('td')[columnIndex].dataset.compare);
      return (numB > numA) ? 1 : (numB < numA) ? -1 : 0;
    };
  
    var switchCmpFunc = {};
    switchCmpFunc[NUMBER_CLASS] = compareColumnNumber;
    switchCmpFunc[STRING_CLASS] = compareColumnString;
    switchCmpFunc[DATA_CLASS] = compareColumnData;
    
    PROTOTYPE.sortRows = function (type, table, th, columnIndex) {
      var rowsOrigin = table.getElementsByTagName('tr');
      var rows = [].slice.call(rowsOrigin);
      rows.shift();
      var isAsc = th.classList.contains(ASC_CLASS);
      rows.sort(function (a, b) {
        var result = switchCmpFunc[type](a, b, columnIndex);
        return isAsc ? result : result * -1;
      });
      replaceRows(table, rows);
    };
  
  }());
  
  PROTOTYPE.registFunctions = function () {
    var self = this;
    Array.prototype.forEach.call(document.getElementsByClassName('sortable'), function (table) {
      Array.prototype.forEach.call(table.getElementsByTagName('th'), function (th, index) {
        var type = th.classList.contains(NUMBER_CLASS) ? NUMBER_CLASS
          : th.classList.contains(STRING_CLASS) ? STRING_CLASS
          : th.classList.contains(DATA_CLASS) ? DATA_CLASS 
          : undefined;
        if (type !== undefined) {
          th.addEventListener(self.eventType('click'), function (eve) {
            self.setSortedColumn(table, th);
            self.sortRows(type, table, th, index);
          });
        }
      });
    });
  };

}());
