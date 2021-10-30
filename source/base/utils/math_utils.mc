import Toybox.System;
import Toybox.Lang;
using Toybox.Math;
module WhatAppBase {
  (:Utils)
  module Utils {
    function min(a as Lang.Number, b as Lang.Number) {
      if (a <= b) {
        return a;
      } else {
        return b;
      }
    }

    function max(a as Lang.Number, b as Lang.Number) {
      if (a >= b) {
        return a;
      } else {
        return b;
      }
    }

    function compareTo(numberA, numberB) {
      if (numberA > numberB) {
        return 1;
      } else if (numberA < numberB) {
        return -1;
      } else {
        return 0;
      }
    }

    function percentageOf(value, max) {
      if (max == 0 || max < 0) {
        return 0.0f;
      }
      return value / (max / 100.0);
    }

    // straight line formula y = slope * x + b;
    function slopeOfLine(x1, y1, x2, y2) {
      var rise_deltaY = y2 - y1;
      var run_deltaX = x2 - x1;
      if (run_deltaX == 0.0) {
        return 0.0f;
      }
      // integer division  * 1.0
      return (rise_deltaY.toFloat() / run_deltaX.toFloat());
    }

    function angleInDegreesBetweenXaxisAndLine(x1, y1, x2, y2) {
      var angleRadians = Math.atan2(y2 - y1, x2 - x1);
      return rad2deg(angleRadians);
    }
  }
}