module WhatAppBase {
  class Point {
    var x;
    var y;
    function initialize(x, y) {
      self.x = x;
      self.y = y;
    }

    function asArray() { return [ x, y ]; }
    function toString() { return "[" + x + "," + y + "]"; }
    function move(dx, dy) { return new Point(x + dx, y + dy); }
  }
}