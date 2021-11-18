import Toybox.Lang;
import Toybox.System;
import Toybox.Activity;
module WhatAppBase {
  class WhatEnergyExpenditure extends WhatInfoBase {
    hidden var energyExpenditure as Float = 0.0f;          // kcal/min
    hidden var targetEngergyExpenditure as Float = 10.0f;  // kcal / min

    function initialize() { WhatInfoBase.initialize(); }

    function setTargetEngergyExpenditure(targetEngergyExpenditure as Float) as Void {
      self.targetEngergyExpenditure = targetEngergyExpenditure;
    }

    function updateInfo(info as Activity.Info) as Void {
      if (info has : energyExpenditure) {
        if (info.energyExpenditure != null) {
          energyExpenditure = info.energyExpenditure as Float;
        } else {
          energyExpenditure = 0.0f;
        }
      }
    }

    function getZoneInfo() as ZoneInfo { return _getZoneInfo(getEnergyExpenditure()); }
    function getValue() as WhatValue { return getEnergyExpenditure(); }
    function getFormattedValue() as String { return getEnergyExpenditure().format("%.1f"); }
    function getUnits() as String { return "kcal/m"; }
    function getLabel() as String { return "Energy exp"; }

    // --
    hidden function getEnergyExpenditure() as Float {
      if (energyExpenditure == null) {
        return 0.0f;
      }
      return self.energyExpenditure;
    }

    hidden function getFormatString() as String { return "%.1f"; }

    hidden function _getZoneInfo(energyExpenditure as Float) as ZoneInfo {
      var label = "Energy exp";
      if (energyExpenditure == null || energyExpenditure == 0) {
        return new ZoneInfo(0, label, Graphics.COLOR_WHITE,
                            Graphics.COLOR_BLACK, 0, null);
      }

      var percOfTarget = Utils.percentageOf(energyExpenditure, targetEngergyExpenditure);

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