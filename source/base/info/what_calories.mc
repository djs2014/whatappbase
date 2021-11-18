import Toybox.Lang;
import Toybox.System;
import Toybox.Activity;
module WhatAppBase {
  class WhatCalories extends WhatInfoBase {
    hidden var calories as Number = 0;           // kcal
    hidden var targetCalories as Number = 2000;  // kcal

    hidden var elapsedTime as Number = 0;  // msec

    function initialize() { WhatInfoBase.initialize(); }

    function setTargetCalories(targetCalories as Number) as Void { self.targetCalories = targetCalories; }

    function updateInfo(info as Activity.Info) as Void {
      if (info has :calories) {
        if (info.calories != null) {
          calories = info.calories as Number;
        } else {
          calories = 0;
        }
      }
      if (info has :elapsedTime) {
        if (info.elapsedTime != null) {
          elapsedTime = info.elapsedTime as Number;
        } else {
          elapsedTime = 0;
        }
      }
    }

    function getZoneInfo() as ZoneInfo { return _getZoneInfo(getCalories()); }
    function getValue() as WhatValue { return getCalories(); }
    function getFormattedValue() as String { return getCalories().format("%.0f"); }
    function getUnits() as String { return "kcal"; }
    function getLabel() as String { return "Calories"; }

    function getAltZoneInfo() as ZoneInfo { return _getZoneInfo(getAvgCaloriesPerMin()); }
    function getAltValue() as WhatValue { return getAvgCaloriesPerMin(); }
    function getAltFormattedValue() as String { return getAvgCaloriesPerMin().format("%.0f"); }
    function getAltUnits() as String { return "kcal/min"; }
    function getAltLabel() as String { return "Calories"; }

    function getCalories() as Number {
      if (calories == null) {
        return 0;
      }
      return self.calories;
    }

    // @@ TODO see getAltZoneInfo colors/target
    function getAvgCaloriesPerMin() as Float {
      if (elapsedTime == null || elapsedTime == 0) {
        return 0.0f;
      }
      return calories / (elapsedTime * 1000.0 * 60.0);
    }

    // @@TODO ->
    // https://www.verywellfit.com/metabolism-facts-101-3495605
    // Harris-Benedict Equation for BMR:
    // Men:  BMR = 88.362 + (13.397 x weight in kg) + (4.799 x height in cm) -
    // (5.677 x age in years) Women: BMR = 447.593 + (9.247 x weight in kg) +
    // (3.098 x height in cm) - (4.330 x age in years) Women: Average BMR 1,400
    // calories per day Men: Average BMR just over 1,600 calories per day
    // --> percof chart
    function _getZoneInfo(cal as Numeric) as ZoneInfo {
      var label = "Calories";
      if (cal == null || cal == 0) {
        return new ZoneInfo(0, label, Graphics.COLOR_WHITE,
                            Graphics.COLOR_BLACK, 0, null);
      }

      var percOfTarget = Utils.percentageOf(cal, targetCalories);
      var color = percentageToColor(percOfTarget);
      var color100perc = null;
      if (percOfTarget > 100) {
        color100perc = percentageToColor(100);
      }
      if (percOfTarget < 65) {
        return new ZoneInfo(1, label, color, Graphics.COLOR_BLACK, percOfTarget,
                            color100perc);
      }
      if (percOfTarget < 75) {
        return new ZoneInfo(2, label, color, Graphics.COLOR_BLACK, percOfTarget,
                            color100perc);
      }
      if (percOfTarget < 85) {
        return new ZoneInfo(3, label, color, Graphics.COLOR_BLACK, percOfTarget,
                            color100perc);
      }
      if (percOfTarget < 95) {
        return new ZoneInfo(3, label, color, Graphics.COLOR_BLACK, percOfTarget,
                            color100perc);
      }
      if (percOfTarget < 105) {
        return new ZoneInfo(4, label, color, Graphics.COLOR_BLACK, percOfTarget,
                            color100perc);
      }
      if (percOfTarget < 115) {
        return new ZoneInfo(5, label, color, Graphics.COLOR_BLACK, percOfTarget,
                            color100perc);
      }
      if (percOfTarget < 125) {
        return new ZoneInfo(6, label, color, Graphics.COLOR_BLACK, percOfTarget,
                            color100perc);
      }

      return new ZoneInfo(7, label, color, Graphics.COLOR_BLACK, percOfTarget,
                          color100perc);
    }
  }
}