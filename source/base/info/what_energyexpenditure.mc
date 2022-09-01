import Toybox.Lang;
import Toybox.System;
import Toybox.Activity;
module WhatAppBase {
  class WhatEnergyExpenditure extends WhatInfoBase {
    hidden var energyExpenditure as Float = 0.0f;          // kcal/min
    hidden var targetEngergyExpenditure as Float = 10.0f;  // kcal / min

    hidden var ticks as Number = 0;
    hidden var avgEnergyExpenditure as Double = 0.0d;  
    hidden var maxEnergyExpenditure as Float = 0.0f;

    function initialize() { WhatInfoBase.initialize(); }

    function setTargetEngergyExpenditure(targetEngergyExpenditure as Float) as Void {
      self.targetEngergyExpenditure = targetEngergyExpenditure;
    }

    function updateInfo(info as Activity.Info) as Void {
      WhatInfoBase.updateInfo(info);
      // mActivityPaused = activityIsPaused(info);
      if (info has : energyExpenditure) {
        if (info.energyExpenditure != null) {
          energyExpenditure = info.energyExpenditure as Float;
        } else {
          energyExpenditure = 0.0f;
        }
      }

      ticks = ticks + 1;
      var a = 1 / ticks.toDouble();
      var b = 1 - a;
      avgEnergyExpenditure = (a * energyExpenditure) + b * avgEnergyExpenditure;
            
      maxEnergyExpenditure = Utils.max(maxEnergyExpenditure, energyExpenditure) as Float;
    }

    function getZoneInfo() as ZoneInfo { return _getZoneInfo(getEnergyExpenditure(), true); }
    function getValue() as WhatValue { return getEnergyExpenditure(); }
    function getFormattedValue() as String { return getEnergyExpenditure().format("%.1f"); }
    function getUnits() as String { return "kcal/m"; }
    function getLabel() as String { return "Energy exp"; }


    function getAltZoneInfo() as ZoneInfo { return _getZoneInfo(getAvgEnergyExpenditure(), false); }
    function getAltValue() as WhatValue { return getAvgEnergyExpenditure(); }
    function getAltFormattedValue() as String { return getAvgEnergyExpenditure().format("%.1f"); }
    function getAltUnits() as String { return "kcal/m"; }
    function getAltLabel() as String { return "Energy exp"; }

    function getMaxValue() as WhatValue { return getMaxEnergyExpenditure(); }
    function getMaxZoneInfo() as ZoneInfo { return _getZoneInfo(getMaxEnergyExpenditure(), false); }

    // --
    hidden function getEnergyExpenditure() as Float {
      if (mActivityPaused) {
        return getAvgEnergyExpenditure().toFloat();
      }

      if (energyExpenditure == null) {
        return 0.0f;
      }
      return self.energyExpenditure;
    }
  
    function getAvgEnergyExpenditure() as Double {  
      return self.avgEnergyExpenditure;
    }

    function getMaxEnergyExpenditure() as Float {  
      return self.maxEnergyExpenditure;
    }

    hidden function getFormatString() as String { return "%.1f"; }

    hidden function _getZoneInfo(energyExpenditure as Numeric, showAverageWhenPaused as Boolean) as ZoneInfo {
      if (showAverageWhenPaused && mActivityPaused) {
        return new ZoneInfo(0, "Avg. EE", Graphics.COLOR_WHITE,
                            Graphics.COLOR_BLACK, 0, null);
      }

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