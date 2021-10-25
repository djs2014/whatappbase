module WhatAppBase {
import Toybox.Activity;
import Toybox.Lang;
import Toybox.System;
  using WhatUtils as Utils;

  class WhatAltitude extends WhatBase {
    hidden var previousAltitude = 0;
    hidden var currentAltitude = 0;
    hidden var totalAscent = 0;
    hidden var totalDescent = 0;

    function initialize() { WhatBase.initialize(); }

    function updateInfo(info as Activity.Info) {
      if (info has : altitude) {
        previousAltitude = currentAltitude;
        if (info.altitude) {
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

    function getCurrentAltitude() {
      if (currentAltitude == null) {
        return 0;
      }
      return self.currentAltitude;
    }

    function getTotalAscent() {
      if (totalAscent == null) {
        return 0;
      }
      return self.totalAscent;
    }

    function getTotalDescent() {
      if (totalDescent == null) {
        return 0;
      }
      return self.totalDescent;
    }

    function getUnitsLong() as String { return "meter"; }

    function getUnits() as String {
      if (devSettings.distanceUnits == System.UNIT_STATUTE) {
        return "f";
      } else {
        return "m";
      }
    }

    function convertToMetricOrStatute(value) {
      if (devSettings.elevationUnits == System.UNIT_STATUTE) {        
        value = Utils.meterToFeet(value);
      }
      return value;
    }

    function getFormatString(fieldType) as String { return "%.0f"; }

    // @@TODO - tree level info etc.. climate zones something .. or amount of
    // oxygen
    function getZoneInfo(distance) as ZoneInfo {
      distance = currentAltitude;
      if (distance == null || distance == 0) {
        return new ZoneInfo(0, "Altitude", Graphics.COLOR_WHITE,
                            Graphics.COLOR_BLACK, 0, null);
      }

      return new ZoneInfo(7, "Altitude", Graphics.COLOR_WHITE,
                          Graphics.COLOR_BLACK, 0, null);
    }
  }
}