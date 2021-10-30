module WhatAppBase {import Toybox.Activity;
import Toybox.Lang;
import Toybox.System;

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
    // System.println("alt: " + currentAltitude + " dist: " + elapsedDistance);
    // System.println(grade.format("%.2f") + " %");
  }

  function getCurrentAltitude() {
    if (currentAltitude == null) {
      return 0;
    }
    return self.currentAltitude;
  }

  function getCurrentDistance() {
    if (elapsedDistance == null) {
      return 0;
    }
    return self.elapsedDistance;
  }

  function getGrade() {
    if (grade) {
      return grade;
    } else {
      return 0.0f;
    }
  }

  function getUnitsLong() as String { return "%"; }

  function getUnits() as String { return "%"; }

  function getFormatString(fieldType) as String {
    switch (fieldType) {
      case Types.OneField:
      case Types.WideField:
        return "%.2f";
      case Types.SmallField:
      default:
        return "%.1f";
    }
  }

  function getZoneInfo(distance) as ZoneInfo {
    distance = grade;
    if (distance == null || distance == 0) {
      return new ZoneInfo(0, "Grade", Graphics.COLOR_WHITE,
                          Graphics.COLOR_BLACK, 0, null);
    }
    var color = getGradeColor(grade);

    return new ZoneInfo(0, "Grade", color, Graphics.COLOR_BLACK, 0, null);
  }

  hidden function getGradeColor(grade) {
    if (grade < -12) {
      return WhatColor.COLOR_WHITE_DK_BLUE_4;
    }
    if (grade < -10) {
      return WhatColor.COLOR_WHITE_DK_BLUE_3;
    }
    if (grade < -4) {
      return WhatColor.COLOR_WHITE_BLUE_3;
    }

    if (grade < 0) {
      return WhatColor.COLOR_WHITE_LT_GREEN_3;
    }
    if (grade < 4) {
      return WhatColor.COLOR_WHITE_GREEN_3;
    }

    if (grade < 6) {
      return WhatColor.COLOR_WHITE_YELLOW_3;
    }
    if (grade < 8) {
      return WhatColor.COLOR_WHITE_ORANGE_3;
    }
    if (grade < 10) {
      return WhatColor.COLOR_WHITE_ORANGERED_3;
    }
    if (grade < 12) {
      return WhatColor.COLOR_WHITE_ORANGERED2_3;
    }
    if (grade < 14) {
      return WhatColor.COLOR_WHITE_RED_3;
    }
    if (grade < 15) {
      return WhatColor.COLOR_WHITE_DK_RED_3;
    }
    if (grade < 16) {
      return WhatColor.COLOR_WHITE_PURPLE_3;
    }
    if (grade < 17) {
      return WhatColor.COLOR_WHITE_DK_PURPLE_3;
    }
    return WhatColor.COLOR_WHITE_DK_PURPLE_4;
  }
}
}