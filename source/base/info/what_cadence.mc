import Toybox.Lang;
import Toybox.System;
import Toybox.Activity;
module WhatAppBase {
  class WhatCadence extends WhatInfoBase {
    hidden var currentCadence as Number = 0;
    hidden var avarageCadence as Number = 0;
    hidden var maxCadence as Number = 0;
    hidden var targetCadence as Number = 30;

    function initialize() { WhatInfoBase.initialize(); }

    function setTargetCadence(targetCadence as Number) as Void { self.targetCadence = targetCadence; }

    function updateInfo(info as Activity.Info) as Void {
      mActivityPaused = activityIsPaused(info);
      if (info has :currentCadence) {
        if (info.currentCadence != null) {
          currentCadence = info.currentCadence as Number;
        } else {
          currentCadence = 0;
        }
      }

      if (info has :averageCadence) {
        if (info.averageCadence != null) {
          avarageCadence = info.averageCadence as Number;
        } else {
          avarageCadence = 0;
        }
      }
      if (info has :maxCadence) {
        if (info.maxCadence != null) {
          maxCadence = info.maxCadence as Number;
        } else {
          maxCadence = 0;
        }
      }
    }

    function getZoneInfo() as ZoneInfo { return _getZoneInfo(getCurrentCadence(), true); }
    function getValue() as WhatValue { return getCurrentCadence(); }
    function getFormattedValue() as String { return getCurrentCadence().format("%.0f"); }
    function getUnits() as String { return "rpm"; }
    function getLabel() as String { return "Cadence"; }

    function getAltZoneInfo() as ZoneInfo { return _getZoneInfo(getAverageCadence(), false); }
    function getAltValue() as WhatValue { return getAverageCadence(); }
    function getAltFormattedValue() as String { return getAverageCadence().format("%.0f"); }
    function getAltUnits() as String { return "rpm"; }
    function getAltLabel() as String { return "Avg cadence"; }

    function getMaxValue() as WhatValue { return getMaxCadence(); }
    function getMaxZoneInfo() as ZoneInfo { return _getZoneInfo(getMaxCadence(), false); }

    // --
    hidden function getAverageCadence() as Number {
      if (avarageCadence == null) {
        return 0;
      }
      return self.avarageCadence;
    }

    hidden function getMaxCadence() as Number {
      if (maxCadence == null) {
        return 0;
      }
      return self.maxCadence;
    }

    hidden function getCurrentCadence() as Number {
      if (mActivityPaused) {
        return getAverageCadence();
      }
      if (currentCadence == null) {
        return 0;
      }
      return self.currentCadence;
    }

    hidden function _getZoneInfo(rpm as Number, showAverageWhenPaused as Boolean) as ZoneInfo {
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