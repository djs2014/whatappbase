import Toybox.Lang;
import Toybox.System;
import Toybox.Activity;
using WhatAppBase.Types;
using WhatAppBase.Colors;
module WhatAppBase {
  class WhatInfoBase {
    hidden var mFieldType = Types.SmallField;
    hidden var mDevSettings;
    hidden var mAvailable = true as Lang.Boolean;
    hidden var mLabelHidden = false as Lang.Boolean;
    hidden var mActivityPaused = false as Lang.Boolean;
    hidden var mDebug = false as Lang.Boolean;

    function initialize() { mDevSettings = System.getDeviceSettings(); }

    function isAvailable() as Lang.Boolean { return mAvailable; }
    function isLabelHidden() as Lang.Boolean { return mLabelHidden; }

    function setFieldType(fieldType as Types) as Void { mFieldType = fieldType; }
    function getFieldType() { return mFieldType; }

    function setDebug(debug) as Void { mDebug = debug; }
    function isDebug() as Boolean { return mDebug; }

    function activityIsPaused(info as Activity.Info) as Lang.Boolean {
      if (info has : timerState) {
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
    function getValue() { return 0.0f; }
    function getFormattedValue() as Lang.String { return ""; }
    function getUnits() as Lang.String { return ""; }
    function getLabel() as Lang.String { return ""; }

    function getAltZoneInfo() as ZoneInfo {
      return new ZoneInfo(0, "", Graphics.COLOR_WHITE, Graphics.COLOR_BLACK, 0,
                          null);
    }
    function getAltValue() { return 0.0f; }
    function getAltFormattedValue() as Lang.String { return ""; }
    function getAltUnits() as Lang.String { return getUnits(); }
    function getAltLabel() as Lang.String { return ""; }

    function getMaxValue() { return 0.0f; }
    function getMaxZoneInfo() as ZoneInfo {
      return new ZoneInfo(0, "", Graphics.COLOR_WHITE, Graphics.COLOR_BLACK, 0,
                          null);
    }
    // function convertToDisplayFormat ->
    //  function getFormattedValue(value, fieldType) as Lang.String {
    //   if (value == null) {
    //     return "";
    //   }
    //   value = convertToMetricOrStatute(value);
    //   return value.format(getFormatString(fieldType));
    // }
    // function getUnitsLong() as Lang.String { return ""; } @@ depricated

    // function getFormatString(fieldType) as Lang.String {
    //   switch (fieldType) {
    //     case Types.OneField:
    //     case Types.WideField:
    //     case Types.SmallField:
    //     default:
    //       return "%.0f";
    //   }
    // }

    // "Statute" gives distance in miles, elevation in feet, temperature in
    // Fahrenheit. "Metric" gives distance in km, elevation in metres,
    // temperature in Celsius.
    function convertToMetricOrStatute(value) { return value; }

    function percentageToColor(percentage) {
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
        return Colors.COLOR_WHITE_ORANGERED_2;  // @@ diff color? _4
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