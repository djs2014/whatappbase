module WhatAppBase {
import Toybox.Lang;
import Toybox.System;
import Toybox.Activity;
 

  class WhatEngergyExpenditure extends WhatBase {
    hidden var energyExpenditure = 0.0f;          // kcal/min
    hidden var targetEngergyExpenditure = 10.0f;  // kcal / min

    function initialize() { WhatBase.initialize(); }

    function setTargetEngergyExpenditure(targetEngergyExpenditure) {
      self.targetEngergyExpenditure = targetEngergyExpenditure;
    }

    function updateInfo(info as Activity.Info) {
      if (info has : energyExpenditure) {
        if (info.energyExpenditure) {
          energyExpenditure = info.energyExpenditure;
        } else {
          energyExpenditure = 0.0f;
        }
      }
    }

    function getEnergyExpenditure() {
      if (energyExpenditure == null) {
        return 0;
      }
      return self.energyExpenditure;
    }

    // @@ long for Top view -> getUnitsTop
    function getUnitsLong() as String { return "kcal/min"; }
    // @@ short for left/right or bottom
    function getUnits() as String { return "kcal/m"; }

    function getFormatString(fieldType) as String { return "%.1f"; }

    function getZoneInfo(energyExpenditure) {
      var label = "Energy exp";
      if (energyExpenditure == null || energyExpenditure == 0) {
        return new ZoneInfo(0, label, Graphics.COLOR_WHITE,
                            Graphics.COLOR_BLACK, 0, null);
      }

      var percOfTarget =
          percentageOf(energyExpenditure, targetEngergyExpenditure);

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