import Toybox.Lang;
import Toybox.System;
import Toybox.Activity;
module WhatAppBase {
  class WhatSpeed extends WhatInfoBase {
    hidden var currentSpeed = 0;
    hidden var avarageSpeed = 0;
    hidden var maxSpeed = 0;
    hidden var targetSpeed = 30;

    function initialize() { WhatInfoBase.initialize(); }

    function setTargetSpeed(targetSpeed) { self.targetSpeed = targetSpeed; }

    function updateInfo(info as Activity.Info) {
      mAvailable = false;
      mActivityPaused = activityIsPaused(info);
      if (info has : currentSpeed) {
        mAvailable = true;
        if (info.currentSpeed != null) {
          // speed is in meters per second
          currentSpeed = Utils.mpsToKmPerHour(info.currentSpeed);
        } else {
          currentSpeed = 0.0f;
        }
      }

      if (info has : averageSpeed) {
        if (info.averageSpeed != null) {
          avarageSpeed = Utils.mpsToKmPerHour(info.averageSpeed);
        } else {
          avarageSpeed = 0.0f;
        }
      }
      if (info has : maxSpeed) {
        if (info.maxSpeed != null) {
          maxSpeed = Utils.mpsToKmPerHour(info.maxSpeed);
        } else {
          maxSpeed = 0.0f;
        }
      }
    }

    function getZoneInfo() as ZoneInfo {
      return _getZoneInfo(getCurrentSpeed());
    }
    function getValue() { return convertToMetricOrStatute(getCurrentSpeed()); }
    function getFormattedValue() as Lang.String {
      return convertToMetricOrStatute(getCurrentSpeed()).format("%.1f");
    }
    function getUnits() as String {
      if (mDevSettings.distanceUnits == System.UNIT_STATUTE) {
        return "mi/h";
      } else {
        return "km/h";
      }
    }
    function getLabel() as Lang.String { return "Speed"; }

    function getAltZoneInfo() as ZoneInfo {
      return _getZoneInfo(getAverageSpeed());
    }
    function getAltValue() {
      return convertToMetricOrStatute(getAverageSpeed());
    }
    function getAltFormattedValue() as Lang.String {
      return convertToMetricOrStatute(getAverageSpeed()).format("%.1f");
    }
    function getAltUnits() as String { return getUnits(); }
    function getAltLabel() as Lang.String { return "Avg speed"; }

    // --
    hidden function getAverageSpeed() {
      if (avarageSpeed == null) {
        return 0;
      }
      return self.avarageSpeed;
    }

    hidden function getMaxSpeed() {
      if (maxSpeed == null) {
        return 0;
      }
      return self.maxSpeed;
    }

    hidden function getCurrentSpeed() {
      if (mActivityPaused) {
        return getAverageSpeed();
      }

      if (currentSpeed == null) {
        return 0;
      }
      return self.currentSpeed;
    }

    hidden function convertToMetricOrStatute(value) {
      if (mDevSettings.distanceUnits == System.UNIT_STATUTE) {
        value = Utils.kilometerToMile(value);
      }
      return value;
    }

    hidden function _getZoneInfo(speed) {
      if (mActivityPaused) {
        return new ZoneInfo(0, "Avg. Speed", Graphics.COLOR_WHITE,
                            Graphics.COLOR_BLACK, 0, null);
      }

      var label = "Speed";
      if (speed == null || speed == 0) {
        return new ZoneInfo(0, label, Graphics.COLOR_WHITE,
                            Graphics.COLOR_BLACK, 0, null);
      }
      var percOfTarget = Utils.percentageOf(speed, targetSpeed);
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