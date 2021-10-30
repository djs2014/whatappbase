module WhatAppBase {
import Toybox.Lang;
import Toybox.System;
import Toybox.Activity;

  class WhatBase {
    var fieldType = SmallField;
    hidden var devSettings;
    hidden var available = true;
    hidden var activityPaused = false;

    function initialize() { devSettings = System.getDeviceSettings(); }

    function isAvailable() { return available; }
    function setFieldType(fieldType) { self.fieldType = fieldType; }

    function updateInfo(info as Activity.Info) {}
    function activityIsPaused(info as Activity.Info) {
      if (info has : timerState) {
        return info.timerState == Activity.TIMER_STATE_PAUSED;
      }
      return false;
    }
    // function showAverageWhenPaused() {
    //   return showAverageWhenActivityPaused && activityPaused;
    // }

    function getZoneInfo(value) as ZoneInfo {
      return new ZoneInfo(0, "", Graphics.COLOR_WHITE, Graphics.COLOR_BLACK, 0,
                          null);
    }

    function getUnits() as String { return ""; }

    function getUnitsLong() as String { return ""; }

    function getFormatString(fieldType) as String {
      switch (fieldType) {
        case OneField:
        case WideField:
        case SmallField:
        default:
          return "%.0f";
      }
    }

    // "Statute" gives distance in miles, elevation in feet, temperature in
    // Fahrenheit. "Metric" gives distance in km, elevation in metres,
    // temperature in Celsius.
    function convertToMetricOrStatute(value) { return value; }

    function convertToDisplayFormat(value, fieldType) as Lang.String {
      if (value == null) {
        return "";
      }
      value = convertToMetricOrStatute(value);
      return value.format(getFormatString(fieldType));
    }

    function percentageToColor(percentage) {
      if (percentage == null || percentage == 0) {
        return Graphics.COLOR_WHITE;
      }
      if (percentage < 45) {
        return WhatColor.COLOR_WHITE_GRAY_2;
      }
      if (percentage < 55) {
        return WhatColor.COLOR_WHITE_GRAY_3;
      }
      if (percentage < 65) {
        return WhatColor.COLOR_WHITE_BLUE_3;
      }
      if (percentage < 70) {
        return WhatColor.COLOR_WHITE_DK_BLUE_3;
      }
      if (percentage < 75) {
        return WhatColor.COLOR_WHITE_LT_GREEN_3;
      }
      if (percentage < 80) {
        return WhatColor.COLOR_WHITE_GREEN_3;
      }
      if (percentage < 85) {
        return WhatColor.COLOR_WHITE_YELLOW_3;
      }
      if (percentage < 95) {
        return WhatColor.COLOR_WHITE_ORANGE_3;
      }
      if (percentage == 100) {
        return WhatColor.COLOR_WHITE_ORANGERED_2;  // @@ diff color? _4
      }
      if (percentage < 105) {
        return WhatColor.COLOR_WHITE_ORANGERED_3;
      }
      if (percentage < 115) {
        return WhatColor.COLOR_WHITE_ORANGERED2_3;
      }
      if (percentage < 125) {
        return WhatColor.COLOR_WHITE_RED_3;
      }

      if (percentage < 135) {
        return WhatColor.COLOR_WHITE_DK_RED_3;
      }

      if (percentage < 145) {
        return WhatColor.COLOR_WHITE_PURPLE_3;
      }

      if (percentage < 155) {
        return WhatColor.COLOR_WHITE_DK_PURPLE_3;
      }
      return WhatColor.COLOR_WHITE_DK_PURPLE_4;
    }
  }
}