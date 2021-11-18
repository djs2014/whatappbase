import Toybox.Lang;
import Toybox.System;
import Toybox.Activity;
module WhatAppBase {
  class WhatTestField extends WhatInfoBase {
    hidden var value as Numeric = 250 ;
    hidden var altValue as Numeric = 100;
    hidden var targetValue as Numeric = 100;

    function initialize() { WhatInfoBase.initialize(); }

    function setValue(value as Numeric) as Void { self.value = value; }

    function setTargetValue(targetValue as Numeric) as Void { self.targetValue = targetValue; }

    function setAltValue(value as Numeric) as Void  { self.altValue = value; }
    
    function getZoneInfo() as ZoneInfo { return _getZoneInfo(getTestValue(), true); }
    function getValue() as WhatValue { return convertToMetricOrStatute(getTestValue()); }
    function getFormattedValue() as String {
      return convertToMetricOrStatute(getTestValue()).format("%.0f");
    }
    function getUnits() as String { return "test"; }
    function getLabel() as String { return "Test field"; }

    function getAltZoneInfo() as ZoneInfo { return _getZoneInfo(getTestAltValue(), false); }
    function getAltValue() as WhatValue { return convertToMetricOrStatute(getTestAltValue()); }
    function getAltFormattedValue() as String { return convertToMetricOrStatute(getTestAltValue()).format("%.0f"); }
    function getAltUnits() as String { return getUnits(); }
    function getAltLabel() as String { return "Test alt"; }

    function getMaxValue() as WhatValue { return getMaxTestValue(); }
    function getMaxZoneInfo() as ZoneInfo { return _getZoneInfo(getMaxTestValue(), false);
    }
    // --
    hidden function getTestValue() as Numeric {
      if (mActivityPaused) {
        return getTestAltValue();
      }
      if (value == null) {
        return 0;
      }
      return self.value;
    }

    hidden function getTestAltValue() as Numeric {
      if (altValue == null) {
        return 0;
      }
      return self.altValue;
    }

    hidden function getMaxTestValue() as Numeric {
      if (value == null) {
        return 0;
      }
      return self.value + (self.value * 0.2);
    }

    hidden function convertToMetricOrStatute(value as Numeric) as Numeric { return value; }

    hidden function _getZoneInfo(val as Numeric, showAverageWhenPaused as Boolean) as ZoneInfo {
      if (showAverageWhenPaused && mActivityPaused) {
        return new ZoneInfo(0, "Alt value", Graphics.COLOR_WHITE,
                            Graphics.COLOR_BLACK, 0, null);
      }

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