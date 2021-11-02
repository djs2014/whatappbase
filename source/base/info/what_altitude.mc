import Toybox.Activity;
import Toybox.Lang;
import Toybox.System;
module WhatAppBase {
  // ( : Info) module Info {
  class WhatAltitude extends WhatInfoBase {
    hidden var previousAltitude = 0.0f as Lang.Float;
    hidden var currentAltitude = 0.0f as Lang.Float;
    hidden var totalAscent = 0.0f as Lang.Float;
    hidden var totalDescent = 0.0f as Lang.Float;

    function initialize() { WhatInfoBase.initialize(); }

    function updateInfo(info as Activity.Info) as Void {
      if (info has : altitude) {
        previousAltitude = currentAltitude;
        if (info.altitude != null) {
          currentAltitude = info.altitude;
        } else {
          currentAltitude = 0.0f;
        }
      }

      if (info has : totalAscent) {
        if (info.totalAscent) {
          totalAscent = info.totalAscent;
        } else {
          totalAscent = 0.0f;
        }
      }
      if (info has : totalDescent) {
        if (info.totalDescent) {
          totalDescent = info.totalDescent;
        } else {
          totalDescent = 0.0f;
        }
      }
    }

    function getZoneInfo() as ZoneInfo {
      return _getZoneInfo(getCurrentAltitude());
    }
    function getValue()  {
      return convertToMetricOrStatute(getCurrentAltitude());
    }
    function getFormattedValue() as Lang.String {
      return convertToMetricOrStatute(getCurrentAltitude()).format("%.0f");
    }
    function getUnits() as String {
      if (mDevSettings.distanceUnits == System.UNIT_STATUTE) {
        return "f";
      } else {
        return "m";
      }
    }
    function getLabel() as Lang.String { return "Altitude"; }

    function getAltZoneInfo() as ZoneInfo {
      return _getZoneInfo(getTotalAscent());
    }
    function getAltValue()  {
      return convertToMetricOrStatute(getTotalAscent());
    }
    function getAltFormattedValue() as Lang.String {
      return convertToMetricOrStatute(getTotalAscent()).format("%.0f");
    }
    function getAltUnits() as String { return getUnits(); }
    function getAltLabel() as Lang.String { return "Total ascent"; }

    // --
    hidden function getCurrentAltitude() as Lang.Float {
      if (currentAltitude == null) {
        return 0.0f;
      }
      return self.currentAltitude;
    }

    hidden function getTotalAscent() as Lang.Float {
      if (totalAscent == null) {
        return 0.0f;
      }
      return self.totalAscent;
    }

    hidden function getTotalDescent() as Lang.Float {
      if (totalDescent == null) {
        return 0.0f;
      }
      return self.totalDescent;
    }

    hidden function convertToMetricOrStatute(value) {
      if (mDevSettings.elevationUnits == System.UNIT_STATUTE) {
        value = Utils.meterToFeet(value);
      }
      return value;
    }

    hidden function getFormatString(fieldType) as String { return "%.0f"; }

    // @@TODO - tree level info etc.. climate zones something .. or amount of
    // oxygen
    hidden function _getZoneInfo(altitude) as ZoneInfo {
      if (altitude == null || altitude == 0) {
        return new ZoneInfo(0, "Altitude", Graphics.COLOR_WHITE,
                            Graphics.COLOR_BLACK, 0, null);
      }

      return new ZoneInfo(1, "Altitude", Graphics.COLOR_WHITE,
                          Graphics.COLOR_BLACK, 0, null);
    }
  }
}
