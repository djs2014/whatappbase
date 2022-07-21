import Toybox.Activity;
import Toybox.Lang;
import Toybox.System;
module WhatAppBase {
  // ( : Info) module Info {
  class WhatAltitude extends WhatInfoBase {
    hidden var previousAltitude as Float = 0.0f;
    hidden var currentAltitude as Float = 0.0f;
    hidden var totalAscent as Number = 0;
    hidden var totalDescent as Number = 0;
    hidden var targetAltitude as Number = 1500; // meter
    hidden var targetTotalAscent as Number = 2000; // meter

    function initialize() { WhatInfoBase.initialize(); }

    function setTargetAltitude(altitude as Number) as Void { self.targetAltitude = altitude; }
    function setTargetTotalAscent(totalAscent as Number) as Void { self.targetTotalAscent = totalAscent; }

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
          totalAscent = info.totalAscent as Number;          
        } else {
          totalAscent = 0;
        }
      }
      if (info has :totalDescent) {
        if (info.totalDescent != null) {
          totalDescent = info.totalDescent as Number;
        } else {
          totalDescent = 0;
        }
      }      
    }

    function getZoneInfo() as ZoneInfo { return _getZoneInfo(getCurrentAltitude()); }
    function getValue() as WhatValue { return convertToMetricOrStatute(getCurrentAltitude()); }
    function getFormattedValue() as String { return convertToMetricOrStatute(getCurrentAltitude()).format("%.0f"); }
    function getUnits() as String {
      return _getUnits();      
    }
    function getInfo() as String {
      return convertToMetricOrStatute(getTotalAscent()).format("%d") + " " +_getUnits();      
    }
    function getLabel() as String { return "Altitude"; }

    function getAltZoneInfo() as ZoneInfo { return _getZoneInfoTA(getTotalAscent()); }
    function getAltValue() as WhatValue { return convertToMetricOrStatute(getTotalAscent()); }
    function getAltFormattedValue() as String { return convertToMetricOrStatute(getTotalAscent()).format("%d"); }
    function getAltUnits() as String { return _getUnits(); }
    function getAltLabel() as String { return "Total ascent"; }

    // --

    function _getUnits() as String {
      if (mDevSettings.distanceUnits == System.UNIT_STATUTE) {
        return "f";
      } else {
        return "m";
      }
    }

    hidden function getCurrentAltitude() as Float {
      if (currentAltitude == null) {
        return 0.0f;
      }
      return self.currentAltitude;
    }

    hidden function getTotalAscent() as Number {
      if (totalAscent == null) {
        return 0;
      }
      return self.totalAscent;
    }

    hidden function getTotalDescent() as Number {
      if (totalDescent == null) {
        return 0;
      }
      return self.totalDescent;
    }

    hidden function convertToMetricOrStatute(value as Numeric) as Numeric {
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

      var percOfTarget = Utils.percentageOf(altitude, targetAltitude);
      var color = percentageToColor(percOfTarget);
      var color100perc = null;
      if (percOfTarget > 100) {
        color100perc = percentageToColor(100);
      }

      return new ZoneInfo(1, "Altitude", color, Graphics.COLOR_BLACK, percOfTarget, color100perc);      
    }

    hidden function _getZoneInfoTA(totalAscent as Number) as ZoneInfo {
      if (totalAscent == null || totalAscent == 0) {
        return new ZoneInfo(0, "Ascent", Graphics.COLOR_WHITE,
                            Graphics.COLOR_BLACK, 0, null);
      }

      var percOfTarget = Utils.percentageOf(totalAscent, targetTotalAscent);
      var color = percentageToColor(percOfTarget);
      var color100perc = null;
      if (percOfTarget > 100) {
        color100perc = percentageToColor(100);
      }

      return new ZoneInfo(1, "Ascent", color, Graphics.COLOR_BLACK, percOfTarget, color100perc);      
    }
  }
}
