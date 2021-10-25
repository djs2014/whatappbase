module WhatAppBase {import Toybox.Lang;
import Toybox.System;
import Toybox.Activity;

class WhatSpeed extends WhatBase {
  hidden var currentSpeed = 0;
  hidden var avarageSpeed = 0;
  hidden var maxSpeed = 0;
  hidden var targetSpeed = 30;

  function initialize() { WhatBase.initialize(); }

  function setTargetSpeed(targetSpeed) { self.targetSpeed = targetSpeed; }
  function getAverageSpeed() {
    if (avarageSpeed == null) {
      return 0;
    }
    return self.avarageSpeed;
  }

  function getMaxSpeed() {
    if (maxSpeed == null) {
      return 0;
    }
    return self.maxSpeed;
  }

  function updateInfo(info as Activity.Info) {
    available = false;
    activityPaused = activityIsPaused(info);
    if (info has : currentSpeed) {
      available = true;
      if (info.currentSpeed) {
        // speed is in meters per second
        currentSpeed = mpsToKmPerHour(info.currentSpeed);
      } else {
        currentSpeed = 0.0f;
      }
    }

    if (info has : averageSpeed) {
      if (info.averageSpeed) {
        avarageSpeed = mpsToKmPerHour(info.averageSpeed);
      } else {
        avarageSpeed = 0.0f;
      }
    }
    if (info has : maxSpeed) {
      if (info.maxSpeed) {
        maxSpeed = mpsToKmPerHour(info.maxSpeed);
      } else {
        maxSpeed = 0.0f;
      }
    }
  }

  function getCurrentSpeed() {
    if (activityPaused) {
      return getAverageSpeed();
    }

    if (currentSpeed == null) {
      return 0;
    }
    return self.currentSpeed;
  }

  // @@ getUnitsLong -> getUnitsLR Left right circle
  function getUnitsLong() as String { return "km/h"; }

  // @@ Show right metric
  function getUnits() as String {
    if (devSettings.distanceUnits == System.UNIT_STATUTE) {
      return "mi/h";
    } else {
      return "km/h";
    }
  }

  function getFormatString(fieldType) as String {
    return "%.1f";    
  }

  function convertToMetricOrStatute(value) {
    if (devSettings.distanceUnits == System.UNIT_STATUTE) {
      value = kilometerToMile(value);
    }
    return value;
  }

  function getZoneInfo(speed) {
    if (activityPaused) {
      return new ZoneInfo(0, "Avg. Speed", Graphics.COLOR_WHITE,
                          Graphics.COLOR_BLACK, 0, null);  
    }
    
    if (speed == null || speed == 0) {
      return new ZoneInfo(0, "Speed", Graphics.COLOR_WHITE,
                          Graphics.COLOR_BLACK, 0, null);
    }
    var percOfTarget = percentageOf(speed, targetSpeed);
    var label = "Speed";  //(" + percOfTarget.format("%.0f") + "%)";
    var color = percentageToColor(percOfTarget);
    var color100perc = null;
    if (percOfTarget>100){
      color100perc = percentageToColor(100);
    }
    if (percOfTarget < 65) {
      return new ZoneInfo(1, label, color, Graphics.COLOR_BLACK, percOfTarget, color100perc);
    }
    if (percOfTarget < 75) {
      return new ZoneInfo(2, label, color, Graphics.COLOR_BLACK, percOfTarget, color100perc);
    }
    if (percOfTarget < 85) {
      return new ZoneInfo(3, label, color, Graphics.COLOR_BLACK, percOfTarget, color100perc);
    }
    if (percOfTarget < 95) {
      return new ZoneInfo(3, label, color, Graphics.COLOR_BLACK, percOfTarget, color100perc);
    }
    if (percOfTarget < 105) {
      return new ZoneInfo(4, label, color, Graphics.COLOR_BLACK, percOfTarget, color100perc);
    }
    if (percOfTarget < 115) {
      return new ZoneInfo(5, label, color, Graphics.COLOR_BLACK, percOfTarget, color100perc);
    }
    if (percOfTarget < 125) {
      return new ZoneInfo(6, label, color, Graphics.COLOR_BLACK, percOfTarget, color100perc);
    }

    return new ZoneInfo(7, label, color, Graphics.COLOR_BLACK, percOfTarget, color100perc);
  }
}}