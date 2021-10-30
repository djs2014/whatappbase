module WhatAppBase {
import Toybox.Activity;
import Toybox.Lang;
import Toybox.System;
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

      function getCurrentAltitude() as Lang.Float {
        if (currentAltitude == null) {
          return 0.0f;
        }
        return self.currentAltitude;
      }

      function getTotalAscent() as Lang.Float {
        if (totalAscent == null) {
          return 0.0f;
        }
        return self.totalAscent;
      }

      function getTotalDescent() as Lang.Float {
        if (totalDescent == null) {
          return 0.0f;
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

      function convertToMetricOrStatute(value) as Lang.Float {
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
// }