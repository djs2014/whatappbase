using Toybox.UserProfile;
import Toybox.Lang;
import Toybox.System;
import Toybox.Activity;
module WhatAppBase {
  class WhatHeartrate extends WhatInfoBase {
    hidden var currentHeartRate = 0;
    hidden var avarageHeartrate = 0;
    hidden var maxHeartRate = 0;
    hidden var heartRateZones = null;

    function initialize() { WhatInfoBase.initialize(); }

    function initZones() {
      heartRateZones =
          UserProfile.getHeartRateZones(UserProfile.HR_ZONE_SPORT_BIKING);
      // for (var i = 0; i < hrZones.size(); i++) {
      //   System.println(hrZones[i]);
      // }
    }
    function updateInfo(info as Activity.Info) {
      mAvailable = false;
      if (info has : currentHeartRate) {
        if (info.currentHeartRate) {
          currentHeartRate = info.currentHeartRate;
          mAvailable = true;
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

    function getZoneInfo() as ZoneInfo {
      return _getZoneInfo(getCurrentHeartrate());
    }
    function getValue() { return getCurrentHeartrate(); }
    function getFormattedValue() as Lang.String {
      return getCurrentHeartrate().format("%.0f");
    }
    function getUnits() as String { return "bpm"; }
    function getLabel() as Lang.String { return "Heartrate"; }

    function getAltZoneInfo() as ZoneInfo {
      return _getZoneInfo(getAverageHeartrate());
    }
    function getAltValue() { return getAverageHeartrate(); }
    function getAltFormattedValue() as Lang.String {
      return getAverageHeartrate().format("%.0f");
    }
    function getAltUnits() as String { return "bpm"; }
    function getAltLabel() as Lang.String { return "Avg heartrate"; }

    function getMaxValue() { return getMaxHeartrate(); }
    function getMaxZoneInfo() as ZoneInfo {
      return _getZoneInfo(getMaxHeartrate());
    }

    // --
    hidden function getAverageHeartrate() {
      if (avarageHeartrate == null) {
        return 0;
      }
      return self.avarageHeartrate;
    }

    hidden function getMaxHeartrate() {
      if (maxHeartRate == null) {
        return 0;
      }
      return maxHeartRate;
    }

    hidden function getCurrentHeartrate() {
      if (currentHeartRate == null) {
        return 0.0f;
      }
      return currentHeartRate;
    }

    function _getZoneInfo(hr) as ZoneInfo {
      var hrZones = heartRateZones as Lang.Array<Lang.Number>;

      if (hrZones == null || hrZones.size() == 0 || hr == 0 ||
          hr < hrZones[0]) {
        return new ZoneInfo(0, "Heartrate", Graphics.COLOR_WHITE,
                            Graphics.COLOR_BLACK, 0, null);
      }

      var percOfTarget = Utils.percentageOf(hr, hrZones[5]);
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
        return new ZoneInfo(2, "Light", color, Graphics.COLOR_BLACK,
                            percOfTarget, color100perc);
      }
      if (hr < hrZones[3]) {
        return new ZoneInfo(3, "Moderate", color, Graphics.COLOR_BLACK,
                            percOfTarget, color100perc);
      }
      if (hr < hrZones[4]) {
        return new ZoneInfo(4, "Hard", color, Graphics.COLOR_BLACK,
                            percOfTarget, color100perc);
      }
      if (hr < hrZones[5]) {
        return new ZoneInfo(5, "Maximum", color, Graphics.COLOR_BLACK,
                            percOfTarget, color100perc);
      }

      return new ZoneInfo(6, "Extreme", color, Graphics.COLOR_BLACK,
                          percOfTarget, color100perc);
    }
  }
}