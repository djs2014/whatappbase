import Toybox.Lang;
import Toybox.System;
import Toybox.Activity;
module WhatAppBase {
  class WhatCadence extends WhatInfoBase {
    hidden var currentCadence = 0;
    hidden var avarageCadence = 0;
    hidden var maxCadence = 0;
    hidden var targetCadence = 30;

    function initialize() { WhatInfoBase.initialize(); }

    function setTargetCadence(targetCadence) {
      self.targetCadence = targetCadence;
    }

    function updateInfo(info as Activity.Info) {
      mActivityPaused = activityIsPaused(info);
      if (info has : currentCadence) {
        if (info.currentCadence) {
          currentCadence = info.currentCadence;
        } else {
          currentCadence = 0.0f;
        }
      }

      if (info has : averageCadence) {
        if (info.averageCadence) {
          avarageCadence = info.averageCadence;
        } else {
          avarageCadence = 0.0f;
        }
      }
      if (info has : maxCadence) {
        if (info.maxCadence) {
          maxCadence = info.maxCadence;
        } else {
          maxCadence = 0.0f;
        }
      }
    }

    function getZoneInfo() as ZoneInfo {
      return _getZoneInfo(getCurrentCadence(), true);
    }
    function getValue() { return getCurrentCadence(); }
    function getFormattedValue() as Lang.String {
      return getCurrentCadence().format("%.0f");
    }
    function getUnits() as String { return "rpm"; }
    function getLabel() as Lang.String { return "Cadence"; }

    function getAltZoneInfo() as ZoneInfo {
      return _getZoneInfo(getAverageCadence(), false);
    }
    function getAltValue() { return getAverageCadence(); }
    function getAltFormattedValue() as Lang.String {
      return getAverageCadence().format("%.0f");
    }
    function getAltUnits() as String { return "rpm"; }
    function getAltLabel() as Lang.String { return "Avg cadence"; }

    // --
    hidden function getAverageCadence() {
      if (avarageCadence == null) {
        return 0;
      }
      return self.avarageCadence;
    }

    hidden function getMaxCadence() {
      if (maxCadence == null) {
        return 0;
      }
      return self.maxCadence;
    }

    hidden function getCurrentCadence() {
      if (mActivityPaused) {
        return getAverageCadence();
      }
      if (currentCadence == null) {
        return 0;
      }
      return self.currentCadence;
    }

    hidden function _getZoneInfo(rpm, showAverageWhenPaused) {
      if (showAverageWhenPaused && mActivityPaused) {
        return new ZoneInfo(0, "Avg. Cadence", Graphics.COLOR_WHITE,
                            Graphics.COLOR_BLACK, 0, null);
      }
      if (rpm == null || rpm == 0) {
        return new ZoneInfo(0, "Cadence", Graphics.COLOR_WHITE,
                            Graphics.COLOR_BLACK, 0, null);
      }
      var percOfTarget = Utils.percentageOf(rpm, targetCadence);
      var color = percentageToColor(percOfTarget);
      var color100perc = null;
      if (percOfTarget > 100) {
        color100perc = percentageToColor(100);
      }
      if (rpm < 65) {
        return new ZoneInfo(1, "Grinding", color, Graphics.COLOR_BLACK,
                            percOfTarget, color100perc);
      }
      if (rpm < 75) {
        return new ZoneInfo(2, "Recreational", color, Graphics.COLOR_BLACK,
                            percOfTarget, color100perc);
      }
      if (rpm < 85) {
        return new ZoneInfo(3, "Tempo", color, Graphics.COLOR_BLACK,
                            percOfTarget, color100perc);
      }
      if (rpm < 95) {
        return new ZoneInfo(3, "Racer", color, Graphics.COLOR_BLACK,
                            percOfTarget, color100perc);
      }
      if (rpm < 105) {
        return new ZoneInfo(4, "Spinning", color, Graphics.COLOR_BLACK,
                            percOfTarget, color100perc);
      }
      if (rpm < 115) {
        return new ZoneInfo(5, "Attack", color, Graphics.COLOR_BLACK,
                            percOfTarget, color100perc);
      }
      if (rpm < 125) {
        return new ZoneInfo(6, "Sprint", color, Graphics.COLOR_BLACK,
                            percOfTarget, color100perc);
      }

      return new ZoneInfo(7, "Super", color, Graphics.COLOR_BLACK, percOfTarget,
                          color100perc);
    }
  }
}