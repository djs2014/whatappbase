module WhatAppBase {
import Toybox.Activity;
import Toybox.Lang;
import Toybox.System;
  using WhatUtils as Utils;

  class WhatDistance extends WhatBase {
    // in km
    hidden var elapsedDistance = 0.0f;
    hidden var targetDistance = 150.0f;

    function initialize() { WhatBase.initialize(); }
    function setTargetDistance(targetDistance) {
      self.targetDistance = targetDistance;
    }

    function updateInfo(info as Activity.Info) {
      if (info has : elapsedDistance) {
        if (info.elapsedDistance) {
          self.elapsedDistance = info.elapsedDistance / 1000.0;
        } else {
          self.elapsedDistance = 0.0f;
        }
      }
    }

    function getElapsedDistance() {
      if (elapsedDistance == null) {
        return 0;
      }
      return elapsedDistance;
    }

    // returns distance in m or km
    function getElapsedDistanceMorKm() {
      if (elapsedDistance == null) {
        return 0;
      }
      // System.println(elapsedDistance);
      if (elapsedDistance < 1) {
        return elapsedDistance * 1000.0;
      }
      return elapsedDistance;
    }

    function getUnitsLong() as String {
      if (elapsedDistance < 1) {
        return "meter";
      }
      return "kilometer";
    }

    function getUnits() as String {
      if (devSettings.distanceUnits == System.UNIT_STATUTE) {
        if (elapsedDistance < 1) {
          return "f";
        }
        return "mi";
      } else {
        if (elapsedDistance < 1) {
          return "m";
        }
        return "km";
      }

      if (elapsedDistance < 1) {
        return "m";
      }
      return "km";
    }

    function convertToMetricOrStatute(value) {
      if (elapsedDistance < 1) {
        if (devSettings.distanceUnits == System.UNIT_STATUTE) {
          value = Utils.meterToFeet(value);
        }
      } else {
        if (devSettings.distanceUnits == System.UNIT_STATUTE) {
          value = Utils.kilometerToMile(value);
        }
      }
      return value;
    }

    function getFormatString(fieldType) as String {
      switch (fieldType) {
        case OneField:
        case WideField:
          if (elapsedDistance < 1) {
            return "%.0f";
          }
          return "%.2f";
        case SmallField:
        default:
          if (elapsedDistance < 1) {
            return "%.0f";
          }
          if (elapsedDistance < 100) {
            return "%.2f";
          }
          return "%.1f";
      }
    }

    //  160 = century 100 = metric century @@ TODO
    function getZoneInfo(dummy) {
      var label = "Distance";
      var distance = elapsedDistance;  // km
      if (distance == null || distance == 0) {
        return new ZoneInfo(0, label, Graphics.COLOR_WHITE,
                            Graphics.COLOR_BLACK, 0, null);
      }
      var percOfTarget = Utils.percentageOf(distance, targetDistance);

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