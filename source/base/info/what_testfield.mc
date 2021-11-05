import Toybox.Lang;
import Toybox.System;
import Toybox.Activity;
module WhatAppBase {
  class WhatTestField extends WhatInfoBase {
    hidden var value = 250;
    hidden var altValue = 100;
    hidden var targetValue = 100;

    function initialize() { WhatInfoBase.initialize(); }

    function setValue(value) { self.value = value; }

    function setTargetValue(targetValue) { self.targetValue = targetValue; }

    function setAltValue(value) { self.altValue = value; }
    // function updateInfo(info as Activity.Info) {
    //   if (info has : value) {
    //     if (info.value) {
    //       value = info.value;
    //     } else {
    //       value = 0.0f;
    //     }
    //   }
    // }

    function getZoneInfo() as ZoneInfo { return _getZoneInfo(getTestValue()); }
    function getValue() { return convertToMetricOrStatute(getTestValue()); }
    function getFormattedValue() as Lang.String {
      return convertToMetricOrStatute(getTestValue()).format("%.0f");
    }
    function getUnits() as String { return "test"; }
    function getLabel() as Lang.String { return "Test field"; }

    function getAltZoneInfo() as ZoneInfo {
      return _getZoneInfo(getTestAltValue());
    }
    function getAltValue() {
      return convertToMetricOrStatute(getTestAltValue());
    }
    function getAltFormattedValue() as Lang.String {
      return convertToMetricOrStatute(getTestAltValue()).format("%.0f");
    }
    function getAltUnits() as String { return getUnits(); }
    function getAltLabel() as Lang.String { return "Test alt"; }

    // --
    hidden function getTestValue() {
      if (value == null) {
        return 0;
      }
      return self.value;
    }

    hidden function getTestAltValue() {
      if (altValue == null) {
        return 0;
      }
      return self.altValue;
    }

    hidden function _getZoneInfo(val) {
      var label = "test value";
      if (val == null || val == 0) {
        return new ZoneInfo(0, label, Graphics.COLOR_WHITE,
                            Graphics.COLOR_BLACK, 0, null);
      }

      var percOfTarget = Utils.percentageOf(val, targetValue);
      var color = percentageToColor(percOfTarget);
      var color100perc = null;
      if (percOfTarget > 100) {
        color100perc = percentageToColor(100);
      }
      if (percOfTarget < 65) {
        return new ZoneInfo(1, label, color, Graphics.COLOR_BLACK, percOfTarget,
                            color100perc);
      }
      if (percOfTarget < 75) {
        return new ZoneInfo(2, label, color, Graphics.COLOR_BLACK, percOfTarget,
                            color100perc);
      }
      if (percOfTarget < 85) {
        return new ZoneInfo(3, label, color, Graphics.COLOR_BLACK, percOfTarget,
                            color100perc);
      }
      if (percOfTarget < 95) {
        return new ZoneInfo(3, label, color, Graphics.COLOR_BLACK, percOfTarget,
                            color100perc);
      }
      if (percOfTarget < 105) {
        return new ZoneInfo(4, label, color, Graphics.COLOR_BLACK, percOfTarget,
                            color100perc);
      }
      if (percOfTarget < 115) {
        return new ZoneInfo(5, label, color, Graphics.COLOR_BLACK, percOfTarget,
                            color100perc);
      }
      if (percOfTarget < 125) {
        return new ZoneInfo(6, label, color, Graphics.COLOR_BLACK, percOfTarget,
                            color100perc);
      }

      return new ZoneInfo(7, label, color, Graphics.COLOR_BLACK, percOfTarget,
                          color100perc);
    }
  }
}