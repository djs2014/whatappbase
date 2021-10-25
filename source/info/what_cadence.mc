module WhatAppBase {
  import Toybox.Lang;
import Toybox.System;
import Toybox.Activity;
using WhatUtils as Utils;

class WhatCadence extends WhatBase {
  hidden var currentCadence = 0;
  hidden var avarageCadence = 0;
  hidden var maxCadence = 0;
  hidden var targetCadence = 30;

  function initialize() { WhatBase.initialize(); }

  function setTargetCadence(targetCadence) {
    self.targetCadence = targetCadence;
  }
  function getAverageCadence() {
    if (avarageCadence == null) {
      return 0;
    }
    return self.avarageCadence;
  }

  function getMaxCadence() {
    if (maxCadence == null) {
      return 0;
    }
    return self.maxCadence;
  }

  function updateInfo(info as Activity.Info) {
    activityPaused = activityIsPaused(info);
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

  function getCurrentCadence() {
    if (activityPaused) {
      return getAverageCadence();
    }
    if (currentCadence == null) {
      return 0;
    }
    return self.currentCadence;
  }

  function getUnitsLong() as String { return "rpm"; }

  function getUnits() as String { return "rpm"; }

  function getZoneInfo(rpm) {
    if (activityPaused) {
      return new ZoneInfo(0, "Avg. Cadence", Graphics.COLOR_WHITE,
                          Graphics.COLOR_BLACK, 0, null);
    }
    if (rpm == null || rpm == 0) {
      return new ZoneInfo(0, "Cadence", Graphics.COLOR_WHITE,
                          Graphics.COLOR_BLACK, 0, null);
    }
    var percOfTarget = percentageOf(rpm, targetCadence);
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
      return new ZoneInfo(3, "Tempo", color, Graphics.COLOR_BLACK, percOfTarget,
                          color100perc);
    }
    if (rpm < 95) {
      return new ZoneInfo(3, "Racer", color, Graphics.COLOR_BLACK, percOfTarget,
                          color100perc);
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