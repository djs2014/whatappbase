import Toybox.Lang;
import Toybox.System;
import Toybox.Activity;
module WhatAppBase {
  class WhatGrade extends WhatInfoBase {
    hidden var previousAltitude = 0;
    hidden var currentAltitude = 0;
    hidden var previousElapsedDistance = 0;
    hidden var elapsedDistance = 0;
    hidden var grade = 0.0f;  // %

    function initialize() { WhatInfoBase.initialize(); }

    function updateInfo(info as Activity.Info) {
      if (info has : altitude) {
        previousAltitude = currentAltitude;
        if (info.altitude != null) {
          currentAltitude = info.altitude;
        } else {
          currentAltitude = 0.0f;
        }
      }
      if (info has : elapsedDistance) {
        previousElapsedDistance = elapsedDistance;
        if (info.elapsedDistance != null) {
          elapsedDistance = info.elapsedDistance;
        } else {
          elapsedDistance = 0.0f;
        }
      }

      grade = 0.0f;
      if (info has : altitude && info has : elapsedDistance) {
        var rise = currentAltitude - previousAltitude;
        var run = elapsedDistance - previousElapsedDistance;
        if (run != 0) {
          grade = (rise.toFloat() / run.toFloat()) * 100.0;
        }
      }
    }

    function getZoneInfo() as ZoneInfo { return _getZoneInfo(getGrade()); }
    function getValue() { return getGrade(); }
    function getFormattedValue() as Lang.String {
      return getGrade().format("%.1f");
    }
    function getUnits() as String { return "%"; }
    function getLabel() as Lang.String { return "Grade"; }

    // --
    hidden function getCurrentAltitude() {
      if (currentAltitude == null) {
        return 0;
      }
      return self.currentAltitude;
    }

    hidden function getCurrentDistance() {
      if (elapsedDistance == null) {
        return 0;
      }
      return self.elapsedDistance;
    }

    hidden function getGrade() {
      if (grade == null) {
        return 0.0f;
      }
      return grade;
    }

    hidden function _getZoneInfo(grade) as ZoneInfo {
      if (grade == null || grade == 0) {
        return new ZoneInfo(0, "Grade", Graphics.COLOR_WHITE,
                            Graphics.COLOR_BLACK, 0, null);
      }
      var color = getGradeColor(grade);

      return new ZoneInfo(0, "Grade", color, Graphics.COLOR_BLACK, 0, null);
    }

    hidden function getGradeColor(grade) {
      if (grade < -12) {
        return Colors.COLOR_WHITE_DK_BLUE_4;
      }
      if (grade < -10) {
        return Colors.COLOR_WHITE_DK_BLUE_3;
      }
      if (grade < -4) {
        return Colors.COLOR_WHITE_BLUE_3;
      }

      if (grade < 0) {
        return Colors.COLOR_WHITE_LT_GREEN_3;
      }
      if (grade < 4) {
        return Colors.COLOR_WHITE_GREEN_3;
      }

      if (grade < 6) {
        return Colors.COLOR_WHITE_YELLOW_3;
      }
      if (grade < 8) {
        return Colors.COLOR_WHITE_ORANGE_3;
      }
      if (grade < 10) {
        return Colors.COLOR_WHITE_ORANGERED_3;
      }
      if (grade < 12) {
        return Colors.COLOR_WHITE_ORANGERED2_3;
      }
      if (grade < 14) {
        return Colors.COLOR_WHITE_RED_3;
      }
      if (grade < 15) {
        return Colors.COLOR_WHITE_DK_RED_3;
      }
      if (grade < 16) {
        return Colors.COLOR_WHITE_PURPLE_3;
      }
      if (grade < 17) {
        return Colors.COLOR_WHITE_DK_PURPLE_3;
      }
      return Colors.COLOR_WHITE_DK_PURPLE_4;
    }
  }
}