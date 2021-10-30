import Toybox.Lang;
import Toybox.System;
import Toybox.Activity;
using WhatAppBase.Types;
module WhatAppBase {

  class WhatInfoBase {
    var fieldType = Types.SmallField;
    hidden var devSettings;
    hidden var available = true as Lang.Boolean;
    hidden var labelHidden = false as Lang.Boolean;
    hidden var activityPaused = false as Lang.Boolean;

    function initialize() { devSettings = System.getDeviceSettings(); }

    function isAvailable() as Lang.Boolean { return available; }
    function isLabelHidden() as Lang.Boolean { return labelHidden; }
    
    function setFieldType(fieldType) as Void { self.fieldType = fieldType; }

    function updateInfo(info as Activity.Info) as Void{}

    function activityIsPaused(info as Activity.Info) as Lang.Boolean {
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

    function getUnits() as Lang.String { return ""; }

    function getUnitsLong() as Lang.String { return ""; }

    function getFormatString(fieldType) as Lang.String {
      switch (fieldType) {
        case Types.OneField:
        case Types.WideField:
        case Types.SmallField:
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