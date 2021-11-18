using Toybox.UserProfile;
import Toybox.Lang;
import Toybox.System;
import Toybox.Activity;
module WhatAppBase {
  class WhatHeartrate extends WhatInfoBase {
    hidden var currentHeartRate as Number = 0;
    hidden var avarageHeartrate as Number  = 0;
    hidden var maxHeartRate as Number  = 0;
    hidden var heartRateZones as Array<Lang.Number>?;

    function initialize() { WhatInfoBase.initialize(); }

    function initZones() as Void {
      heartRateZones = UserProfile.getHeartRateZones(UserProfile.HR_ZONE_SPORT_BIKING);
      // for (var i = 0; i < hrZones.size(); i++) {
      //   System.println(hrZones[i]);
      // }
    }
    function updateInfo(info as Activity.Info) as Void {
      mAvailable = false;
      if (info has :currentHeartRate) {
        if (info.currentHeartRate != null) {
          currentHeartRate = info.currentHeartRate  as Number;
          mAvailable = true;
        } else {
          currentHeartRate = 0;
        }
      }

      if (info has :averageHeartRate) {
        if (info.averageHeartRate != null) {
          avarageHeartrate = info.averageHeartRate as Number;
        } else {
          avarageHeartrate = 0;
        }
      }

      if (info has :maxHeartRate) {
        if (info.maxHeartRate != null) {
          maxHeartRate = info.maxHeartRate as Number;
        } else {
          maxHeartRate = 0;
        }
      }
    }

    function getZoneInfo() as ZoneInfo {
      return _getZoneInfo(getCurrentHeartrate());
    }
    function getValue() as WhatValue { return getCurrentHeartrate(); }
    function getFormattedValue() as String { return getCurrentHeartrate().format("%.0f"); }
    function getUnits() as String { return "bpm"; }
    function getLabel() as String { return "Heartrate"; }

    function getAltZoneInfo() as ZoneInfo { return _getZoneInfo(getAverageHeartrate()); }
    function getAltValue() as WhatValue { return getAverageHeartrate(); }
    function getAltFormattedValue() as String { return getAverageHeartrate().format("%.0f"); }
    function getAltUnits() as String { return "bpm"; }
    function getAltLabel() as String { return "Avg heartrate"; }

    function getMaxValue() as WhatValue { return getMaxHeartrate(); }
    function getMaxZoneInfo() as ZoneInfo { return _getZoneInfo(getMaxHeartrate()); }

    // --
    hidden function getAverageHeartrate() as Number {
      if (avarageHeartrate == null) {
        return 0;
      }
      return self.avarageHeartrate;
    }

    hidden function getMaxHeartrate() as Number {
      if (maxHeartRate == null) {
        return 0;
      }
      return maxHeartRate;
    }

    hidden function getCurrentHeartrate() as Number {
      if (currentHeartRate == null) {
        return 0;
      }
      return currentHeartRate;
    }

    function _getZoneInfo(hr as Number) as ZoneInfo {
      var hrZones = heartRateZones as Array<Number>;

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