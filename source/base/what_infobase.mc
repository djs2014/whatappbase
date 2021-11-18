import Toybox.Lang;
import Toybox.System;
import Toybox.Activity;
import Toybox.Graphics;
// using WhatAppBase.Types;
// using WhatAppBase.Colors;
module WhatAppBase {
  typedef WhatValue as String or Numeric;
  class WhatInfoBase {
    hidden var mFieldType as Number = Types.SmallField;
    hidden var mDevSettings as System.DeviceSettings = System.getDeviceSettings();
    hidden var mAvailable as Boolean = true;
    hidden var mLabelHidden as Boolean = false;
    hidden var mActivityPaused as Boolean = false;
    hidden var mDebug as Boolean = false;

    function initialize() {}

    function isAvailable() as Boolean { return mAvailable; }
    function isLabelHidden() as Boolean { return mLabelHidden; }

    function setFieldType(fieldType as Number) as Void { mFieldType = fieldType; }
    function getFieldType() as Number { return mFieldType; }

    function setDebug(debug as Boolean) as Void { mDebug = debug; }
    function isDebug() as Boolean { return mDebug; }

    function activityIsPaused(info as Activity.Info) as Boolean {
      if (info has :timerState) {
        return info.timerState == Activity.TIMER_STATE_PAUSED;
      }
      return false;
    }
    // function showAverageWhenPaused() {
    //   return showAverageWhenmActivityPaused && mActivityPaused;
    // }

    // ---
    function updateInfo(info as Activity.Info) as Void {}

    function getZoneInfo() as ZoneInfo {
      return new ZoneInfo(0, "", Graphics.COLOR_WHITE, Graphics.COLOR_BLACK, 0,
                          null);
    }
    function getValue() as WhatValue { return 0.0f; }
    function getFormattedValue() as String { return ""; }
    function getUnits() as String { return ""; }
    function getLabel() as String { return ""; }

    function getAltZoneInfo() as ZoneInfo {
      return new ZoneInfo(0, "", Graphics.COLOR_WHITE, Graphics.COLOR_BLACK, 0,
                          null);
    }
    function getAltValue() as WhatValue { return 0.0f; }
    function getAltFormattedValue() as String { return ""; }
    function getAltUnits() as String { return getUnits(); }
    function getAltLabel() as String { return ""; }

    function getMaxValue() as WhatValue { return 0.0f; }
    function getMaxZoneInfo() as ZoneInfo {
      return new ZoneInfo(0, "", Graphics.COLOR_WHITE, Graphics.COLOR_BLACK, 0,
                          null);
    }
    
    // "Statute" gives distance in miles, elevation in feet, temperature in
    // Fahrenheit. "Metric" gives distance in km, elevation in metres,
    // temperature in Celsius.
    // function convertToMetricOrStatute(value as Numeric) as Numeric { return value; }

    function percentageToColor(percentage as Numeric) as Graphics.ColorType {
      if (percentage == null || percentage == 0) {
        return Graphics.COLOR_WHITE;
      }
      if (percentage < 45) {
        return Colors.COLOR_WHITE_GRAY_2;
      }
      if (percentage < 55) {
        return Colors.COLOR_WHITE_GRAY_3;
      }
      if (percentage < 65) {
        return Colors.COLOR_WHITE_BLUE_3;
      }
      if (percentage < 70) {
        return Colors.COLOR_WHITE_DK_BLUE_3;
      }
      if (percentage < 75) {
        return Colors.COLOR_WHITE_LT_GREEN_3;
      }
      if (percentage < 80) {
        return Colors.COLOR_WHITE_GREEN_3;
      }
      if (percentage < 85) {
        return Colors.COLOR_WHITE_YELLOW_3;
      }
      if (percentage < 95) {
        return Colors.COLOR_WHITE_ORANGE_3;
      }
      if (percentage == 100) {
        return Colors.COLOR_WHITE_ORANGERED_2;  
      }
      if (percentage < 105) {
        return Colors.COLOR_WHITE_ORANGERED_3;
      }
      if (percentage < 115) {
        return Colors.COLOR_WHITE_ORANGERED2_3;
      }
      if (percentage < 125) {
        return Colors.COLOR_WHITE_RED_3;
      }

      if (percentage < 135) {
        return Colors.COLOR_WHITE_DK_RED_3;
      }

      if (percentage < 145) {
        return Colors.COLOR_WHITE_PURPLE_3;
      }

      if (percentage < 155) {
        return Colors.COLOR_WHITE_DK_PURPLE_3;
      }
      return Colors.COLOR_WHITE_DK_PURPLE_4;
    }
  }
}