import Toybox.Lang;
import Toybox.System;

module WhatAppBase {
  (:Utils)
  module Utils {
    typedef Coordinate as Array<Number>;

    class Point {
      var x as Number = 0;
      var y as Number = 0;

      function initialize(x as Number, y as Number) {
        self.x = x;
        self.y = y;
      }

      // @@ asCoordinate
      function asArray() as Coordinate { return [ x, y ] as Coordinate ; }
      function toString() as String { return "[" + x + "," + y + "]"; }
      function move(dx as Number, dy as Number) as Utils.Point { return new Utils.Point(x + dx, y + dy); }
    }
  }
}