module WhatAppBase {using Toybox.UserProfile;
import Toybox.Lang;
import Toybox.System;

class WhateHeartrate extends WhatBase {
  hidden var currentHeartRate = 0;
  hidden var avarageHeartrate = 0;
  hidden var maxHeartRate = 0;
  hidden var hrZones;

  function initialize() { WhatBase.initialize(); }

  function getAverageHeartrate() {
    if (avarageHeartrate == null) {
      return 0;
    }
    return self.avarageHeartrate;
  }

  function getMaxHeartrate() {
    if (maxHeartRate == null) {
      return 0;
    }
    return maxHeartRate;
  }

  function updateInfo(info as Activity.Info) {
    available = false;
    if (info has : currentHeartRate) {
      if (info.currentHeartRate) {
        currentHeartRate = info.currentHeartRate;
        available = true;
      } else {
        currentHeartRate = 0.0f;
      }
    }

    if (info has : averageHeartRate) {
      if (info.averageHeartRate) {
        avarageHeartrate = info.averageHeartRate;
      } else {
        avarageHeartrate = 0.0f;
      }
    }

    if (info has : maxHeartRate) {
      if (info.maxHeartRate) {
        maxHeartRate = info.maxHeartRate;
      } else {
        maxHeartRate = 0.0f;
      }
    }
  }

  function getCurrentHeartrate() {
    if (currentHeartRate == null) {
      return 0.0f;
    }
    return currentHeartRate;
  }

  function initZones() {
    hrZones = UserProfile.getHeartRateZones(UserProfile.HR_ZONE_SPORT_BIKING);
    // for (var i = 0; i < hrZones.size(); i++) {
    //   System.println(hrZones[i]);
    // }
  }

  function getUnitsLong() as String { return "bpm"; }

  function getUnits() as String { return "bpm"; }

  // -> get user profile hr zones
  function getZoneInfo(hr) as ZoneInfo {
    if (hrZones == null || hrZones.size() == 0 || hr == 0 || hr < hrZones[0]) {
      return new ZoneInfo(0, "Heartrate", Graphics.COLOR_WHITE,
                          Graphics.COLOR_BLACK, 0, null);
    }

    var percOfTarget = percentageOf(hr, hrZones[5]);
    var color = percentageToColor(percOfTarget);
    var color100perc = null;
    if (percOfTarget > 100) {
      color100perc = percentageToColor(100);
    }

    if (hr < hrZones[1]) {
      return new ZoneInfo(1, "Very light", color, Graphics.COLOR_BLACK,
                          percOfTarget, color100perc);
    }
    if (hr < hrZones[2]) {
      return new ZoneInfo(2, "Light", color, Graphics.COLOR_BLACK, percOfTarget,
                          color100perc);
    }
    if (hr < hrZones[3]) {
      return new ZoneInfo(3, "Moderate", color, Graphics.COLOR_BLACK,
                          percOfTarget, color100perc);
    }
    if (hr < hrZones[4]) {
      return new ZoneInfo(4, "Hard", color, Graphics.COLOR_BLACK, percOfTarget,
                          color100perc);
    }
    if (hr < hrZones[5]) {
      return new ZoneInfo(5, "Maximum", color, Graphics.COLOR_BLACK,
                          percOfTarget, color100perc);
    }

    return new ZoneInfo(6, "Extreme", color, Graphics.COLOR_BLACK, percOfTarget,
                        color100perc);
  }
}}