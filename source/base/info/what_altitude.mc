import Toybox.Activity;
import Toybox.Lang;
import Toybox.System;
module WhatAppBase {
  // ( : Info) module Info {
  class WhatAltitude extends WhatInfoBase {
    hidden var previousAltitude as Float = 0.0f;
    hidden var currentAltitude as Float = 0.0f;
    hidden var totalAscent as Float = 0.0f;
    hidden var totalDescent as Float = 0.0f;

    function initialize() { WhatInfoBase.initialize(); }

    function updateInfo(info as Activity.Info) as Void {
      if (info has :altitude) {
        previousAltitude = currentAltitude;
        if (info.altitude != null) {
          currentAltitude = info.altitude as Float;
        } else {
          currentAltitude = 0.0f;
        }
      }

      if (info has :totalAscent) {
        if (info.totalAscent != null) {
          totalAscent = info.totalAscent as Float;
        } else {
          totalAscent = 0.0f;
        }
      }
      if (info has :totalDescent) {
        if (info.totalDescent != null) {
          totalDescent = info.totalDescent as Float;
        } else {
          totalDescent = 0.0f;
        }
      }
    }

    function getZoneInfo() as ZoneInfo { return _getZoneInfo(getCurrentAltitude()); }
    function getValue() as WhatValue { return convertToMetricOrStatute(getCurrentAltitude()); }
    function getFormattedValue() as String { return convertToMetricOrStatute(getCurrentAltitude()).format("%.0f"); }
    function getUnits() as String {
      if (mDevSettings.distanceUnits == System.UNIT_STATUTE) {
        return "f";
      } else {
        return "m";
      }
    }
    function getLabel() as String { return "Altitude"; }

    function getAltZoneInfo() as ZoneInfo { return _getZoneInfo(getTotalAscent()); }
    function getAltValue() as WhatValue { return convertToMetricOrStatute(getTotalAscent()); }
    function getAltFormattedValue() as String { return convertToMetricOrStatute(getTotalAscent()).format("%.0f"); }
    function getAltUnits() as String { return getUnits(); }
    function getAltLabel() as String { return "Total ascent"; }

    // --
    hidden function getCurrentAltitude() as Float {
      if (currentAltitude == null) {
        return 0.0f;
      }
      return self.currentAltitude;
    }

    hidden function getTotalAscent() as Float {
      if (totalAscent == null) {
        return 0.0f;
      }
      return self.totalAscent;
    }

    hidden function getTotalDescent() as Float {
      if (totalDescent == null) {
        return 0.0f;
      }
      return self.totalDescent;
    }

    hidden function convertToMetricOrStatute(value as Float) as Float {
      if (mDevSettings.elevationUnits == System.UNIT_STATUTE) {
        value = Utils.meterToFeet(value);
      }
      return value;
    }
    
    // @@TODO - tree level info etc.. climate zones something .. or amount of
    // oxygen
    hidden function _getZoneInfo(altitude as Float) as ZoneInfo {
      if (altitude == null || altitude == 0) {
        return new ZoneInfo(0, "Altitude", Graphics.COLOR_WHITE,
                            Graphics.COLOR_BLACK, 0, null);
      }

      return new ZoneInfo(1, "Altitude", Graphics.COLOR_WHITE,
                          Graphics.COLOR_BLACK, 0, null);
    }
  }
}
