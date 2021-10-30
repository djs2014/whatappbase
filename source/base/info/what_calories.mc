module WhatAppBase {
import Toybox.Lang;
import Toybox.System;
import Toybox.Activity;
 

  class WhatCalories extends WhatInfoBase {
    hidden var calories = 0.0f;           // kcal
    hidden var targetCalories = 2000.0f;  // kcal

    function initialize() { WhatInfoBase.initialize(); }

    function setTargetCalories(targetCalories) {
      self.targetCalories = targetCalories;
    }

    function updateInfo(info as Activity.Info) {
      if (info has : calories) {
        if (info.calories) {
          // speed is in meters per second
          calories = info.calories;
        } else {
          calories = 0.0f;
        }
      }
    }

    function getCalories() {
      if (calories == null) {
        return 0;
      }
      return self.calories;
    }

    function getUnitsLong() as String { return "kcal"; }

    function getUnits() as String { return "kcal"; }

    function getFormatString(fieldType) as String { return "%.0f"; }

    // @@TODO ->
    // https://www.verywellfit.com/metabolism-facts-101-3495605
    // Harris-Benedict Equation for BMR:
    // Men:  BMR = 88.362 + (13.397 x weight in kg) + (4.799 x height in cm) -
    // (5.677 x age in years) Women: BMR = 447.593 + (9.247 x weight in kg) +
    // (3.098 x height in cm) - (4.330 x age in years) Women: Average BMR 1,400
    // calories per day Men: Average BMR just over 1,600 calories per day
    // --> percof chart
    function getZoneInfo(cal) {
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