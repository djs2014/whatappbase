import Toybox.Lang;
import Toybox.System;
import Toybox.Activity;
import Toybox.Graphics;

module WhatAppBase {
  class WhatGrade extends WhatInfoBase {
    hidden var previousAltitude as Float = 0.0f;
    hidden var currentAltitude as Float = 0.0f;
    hidden var previousElapsedDistance as Float = 0.0f;
    hidden var elapsedDistance as Float = 0.0f;
    hidden var grade as Float = 0.0f;  // %
    hidden var targetGrade as Number = 8;  // %

    function initialize() { WhatInfoBase.initialize(); }

    function setTargetGrade(grade as Number) as Void { self.targetGrade = grade; }

    function updateInfo(info as Activity.Info) {
      if (info has :altitude) {
        previousAltitude = currentAltitude;
        if (info.altitude != null) {
          currentAltitude = info.altitude as Float;
        } else {
          currentAltitude = 0.0f;
        }
      }
      if (info has :elapsedDistance) {
        previousElapsedDistance = elapsedDistance;
        if (info.elapsedDistance != null) {
          elapsedDistance = info.elapsedDistance as Float;
        } else {
          elapsedDistance = 0.0f;
        }
      }

      grade = 0.0f;
      if (info has :altitude && info has :elapsedDistance) {
        var rise = currentAltitude - previousAltitude;
        var run = elapsedDistance - previousElapsedDistance;
        if (run != 0.0) {
          grade = (rise.toFloat() / run.toFloat()) * 100.0;
        }
      }
    }

    function getZoneInfo() as ZoneInfo { return _getZoneInfo(getGrade()); }
    function getValue() as WhatValue { return getGrade(); }
    function getFormattedValue() as String { return getGrade().format("%.1f"); }
    function getUnits() as String { return "%"; }
    function getLabel() as String { return "Grade"; }

    // --
    hidden function getCurrentAltitude() as Float {
      if (currentAltitude == null) {
        return 0.0f;
      }
      return self.currentAltitude;
    }

    hidden function getCurrentDistance() as Float {
      if (elapsedDistance == null) {
        return 0.0f;
      }
      return self.elapsedDistance;
    }

    hidden function getGrade() as Float {
      if (grade == null) {
        return 0.0f;
      }
      return grade;
    }

    hidden function _getZoneInfo(grade as Float) as ZoneInfo {
      if (grade == null || grade == 0) {
        return new ZoneInfo(0, "Grade", Graphics.COLOR_WHITE,
                            Graphics.COLOR_BLACK, 0, null);
      }
      //var color = getGradeColor(grade);
      
      var percOfTarget = Utils.percentageOf(Utils.abs(grade), targetGrade);
      var color = percentageToColor(percOfTarget);
      var color100perc = null;
      if (percOfTarget > 100) {
        color100perc = percentageToColor(100);
      }

      return new ZoneInfo(0, "Grade", color, Graphics.COLOR_BLACK, percOfTarget, color100perc);
    }

    // hidden function getGradeColor(grade as Float) as ColorType {
    //   if (grade < -12) {
    //     return Colors.COLOR_WHITE_DK_BLUE_4;
    //   }
    //   if (grade < -10) {
    //     return Colors.COLOR_WHITE_DK_BLUE_3;
    //   }
    //   if (grade < -4) {
    //     return Colors.COLOR_WHITE_BLUE_3;
    //   }

    //   if (grade < 0) {
    //     return Colors.COLOR_WHITE_LT_GREEN_3;
    //   }
    //   if (grade < 4) {
    //     return Colors.COLOR_WHITE_GREEN_3;
    //   }

    //   if (grade < 6) {
    //     return Colors.COLOR_WHITE_YELLOW_3;
    //   }
    //   if (grade < 8) {
    //     return Colors.COLOR_WHITE_ORANGE_3;
    //   }
    //   if (grade < 10) {
    //     return Colors.COLOR_WHITE_ORANGERED_3;
    //   }
    //   if (grade < 12) {
    //     return Colors.COLOR_WHITE_ORANGERED2_3;
    //   }
    //   if (grade < 14) {
    //     return Colors.COLOR_WHITE_RED_3;
    //   }
    //   if (grade < 15) {
    //     return Colors.COLOR_WHITE_DK_RED_3;
    //   }
    //   if (grade < 16) {
    //     return Colors.COLOR_WHITE_PURPLE_3;
    //   }
    //   if (grade < 17) {
    //     return Colors.COLOR_WHITE_DK_PURPLE_3;
    //   }
    //   return Colors.COLOR_WHITE_DK_PURPLE_4;
    // }
  }
}