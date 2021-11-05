import Toybox.Activity;
import Toybox.Lang;
import Toybox.System;
module WhatAppBase {
  class WhatDistance extends WhatInfoBase {
    // in km
    hidden var elapsedDistance = 0.0f as Lang.Float;
    hidden var targetDistance = 150.0f as Lang.Float;

    function initialize() { WhatInfoBase.initialize(); }

    function setTargetDistance(targetDistance as Lang.Float) {
      self.targetDistance = targetDistance;
    }

    function updateInfo(info as Activity.Info) {
      if (info has : elapsedDistance) {
        if (info.elapsedDistance != null) {
          self.elapsedDistance = info.elapsedDistance / 1000.0;
        } else {
          self.elapsedDistance = 0.0f;
        }
      }
    }

    function getZoneInfo() as ZoneInfo {
      return _getZoneInfo(getElapsedDistance());
    }
    function getValue()  {
      return convertToMetricOrStatute(getElapsedDistanceMileorKm());
    }
    function getFormattedValue() as Lang.String {
      return convertToMetricOrStatute(getElapsedDistanceMileorKm())
          .format(getFormatString());
    }
    function getUnits() as String {
      // < 1 km -> feet or meters, above miles or kilometers
      if (mDevSettings.distanceUnits == System.UNIT_STATUTE) {
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
    }
    function getLabel() as Lang.String { return "Distance"; }

    // function getAltZoneInfo() as ZoneInfo {
    //   return _getZoneInfo(getTotalAscent());
    // }
    // function getAltValue()  {
    //   return convertToMetricOrStatute(getTotalAscent());
    // }
    // function getAltFormattedValue() as Lang.String {
    //   return convertToMetricOrStatute(getTotalAscent()).format("%.0f");
    // }
    // function getAltUnits() as String { return getUnits(); }
    // function getAltLabel() as Lang.String { return "Total ascent"; }

    // --
    hidden function getElapsedDistance() as Lang.Float {
      // always in km
      if (elapsedDistance == null) {
        return 0.0f;
      }
      return elapsedDistance;
    }

    // returns distance in m or km
    hidden function getElapsedDistanceMileorKm() as Lang.Float {
      if (elapsedDistance == null) {
        return 0.0f;
      }
      // System.println(elapsedDistance);
      if (elapsedDistance < 1) {
        // convert to meter or feet
        return elapsedDistance * 1000.0f;
      }
      return elapsedDistance;
    }

    hidden function convertToMetricOrStatute(value) as Lang.Float {
      if (elapsedDistance < 1) {
        if (mDevSettings.distanceUnits == System.UNIT_STATUTE) {
          value = Utils.meterToFeet(value);
        }
      } else {
        if (mDevSettings.distanceUnits == System.UNIT_STATUTE) {
          value = Utils.kilometerToMile(value);
        }
      }
      return value;
    }

    hidden function getFormatString() as String {
      if (elapsedDistance < 1) {
        return "%.0f";
      }
      if (elapsedDistance < 100) {
        return "%.2f";
      }
      return "%.1f";

      // switch (fieldType) {
      //   case Types.OneField:
      //   case Types.WideField:
      //     if (elapsedDistance < 1) {
      //       return "%.0f";
      //     }
      //     return "%.2f";
      //   case Types.SmallField:
      //   default:
      //     if (elapsedDistance < 1) {
      //       return "%.0f";
      //     }
      //     if (elapsedDistance < 100) {
      //       return "%.2f";
      //     }
      //     return "%.1f";
      // }
    }

    // @@ TODO labels  160 = century 100 = metric century
    function _getZoneInfo(distance) as ZoneInfo {
      var label = "Distance";
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