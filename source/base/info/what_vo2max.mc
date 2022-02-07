import Toybox.Activity;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Graphics;
using Toybox.UserProfile;
module WhatAppBase {

  // ( : Info) module Info {
  
  class WhatVo2Max extends WhatInfoBase {
    hidden var perSec as Number = 360; // 6min
    hidden var ftp as Number = 250;
    hidden var dataPerSec as Array = [];

    hidden var averagePower as Number = 0;
    hidden var maxPower as Number = 0 ;
    hidden var userWeightKg as Float = 0.0f;

    hidden var lastCheck as Number = 0;
  
    function initialize() { WhatInfoBase.initialize(); }

    function initWeight() as Void {
      var profile = UserProfile.getProfile();
      userWeightKg = 0.0f;
      if (profile.weight == null) { return; }
      var weight = profile.weight as Float;
      userWeightKg = weight / 1000.0;
    }

    function clearData() as Void {
      dataPerSec = [];
    }
    
    function setFtp(ftp as Number) as Void { self.ftp = ftp; }
    function setPerSec(perSec as Number) as Void { self.perSec = perSec; }
   
    // Must be called once per second
    function updateInfo(info as Activity.Info) as Void {
      mAvailable = false;
      mActivityPaused = activityIsPaused(info);

      if (info has :currentPower) {
        mAvailable = true;
        var power = 0;
        if (info.currentPower != null) {
          power = info.currentPower as Number;
        }
        if (Utils.ensureXSecondsPassed(lastCheck, 1)) {
          lastCheck = Time.now().value();
          System.println("Add power: " + lastCheck);
          addPower(power);
        }
      }

      if (info has :averagePower) {
        if (info.averagePower != null) {
          averagePower = info.averagePower as Number;
        } else {
          averagePower = 0;
        }
      }

      if (info has :maxPower) {
        if (info.maxPower != null) {
          maxPower = info.maxPower as Number;
        }
      }
      
    }

    function getZoneInfo() as ZoneInfo { return _getZoneInfo(powerPerX(), true); }
    function getValue() as WhatValue { return getVo2Max(); }
    function getFormattedValue() as String {
      return getVo2Max().format("%.1f");
    }
    function getUnits() as String { return "Vo2Max"; }
    function getLabel() as String { return "Vo2Max"; }

    function getAltZoneInfo() as ZoneInfo {
      return _getZoneInfo(getAveragePower(), false);
    }
    function getAltValue() as WhatValue { return getAveragePower(); }
    function getAltFormattedValue() as String {
      return getAveragePower().format("%.0f");
    }
    function getAltUnits() as String { return "w"; }
    function getAltLabel() as String { return "Avg power"; }

    function getMaxValue() as WhatValue { return getMaxPower(); }
    function getMaxZoneInfo() as ZoneInfo {
      return _getZoneInfo(getMaxPower(), false);
    }
      
    // vo2max = ((6min pow er * 10.8) / weight) + 7    
    hidden function getVo2Max() as Float {
      if (userWeightKg == 0.0f) { return 0.0; }
      var pp6min = powerPerX();
      System.println(pp6min);
      return ((pp6min * 10.8) / userWeightKg) + 7;
    }

    //
    function getPercOfTarget() as Numeric {
      return Utils.percentageOf(powerPerX(), ftp);
    }
    
    // --

    hidden function convertToMetricOrStatute(value as Numeric) as Numeric {
      if (mDevSettings.weightUnits == System.UNIT_STATUTE) {
        value = Utils.kilogramToLbs(value);
      }
      return value;
    }
    hidden function getAveragePower() as Number {
      if (averagePower == null) {
        return 0;
      }
      return self.averagePower;
    }

    hidden function getMaxPower() as Number {
      if (maxPower == null) {
        return 0;
      }
      return self.maxPower;
    }

    hidden function addPower(power as Number) as Void {
      // var dataPerSec = powerDataPerSecond as Array<Number>;
      if (dataPerSec.size() >= perSec) {
        dataPerSec = dataPerSec.slice(1, perSec);
      }

      dataPerSec.add(power);
    }

    hidden function powerPerX() as Number {
      if (mActivityPaused) {
        return getAveragePower();
      }

      var perSec = dataPerSec as Array<Number>;
      if (perSec.size() == 0) {
        return 0;
      }

      var ppx = 0;
      for (var x = 0; x < perSec.size(); x++) {
        ppx = ppx + perSec[x];
      }
      return ppx / perSec.size();
    }

    hidden function powerPerWeight() as Float {
      if (mActivityPaused) {
        return averagePowerPerWeight();
      }
      if (userWeightKg == 0) {
        return 0.0f;
      }
      return powerPerX() / userWeightKg.toFloat();
    }

    hidden function averagePowerPerWeight() as Float {
      if (userWeightKg == 0) {
        return 0.0f;
      }
      return getAveragePower() / userWeightKg.toFloat();
    }

    // https://www.trainerroad.com/blog/cycling-power-zones-training-zones-explained/
    // https://theprologue.wayneparkerkent.com/how-do-you-train-for-cycling-based-on-power-zones/
    // Active Recovery	<= 54% FTP
    // Endurance	55% – 75% FTP
    // Tempo	76% – 87% FTP
    // Sweet Spot	88% – 94% FTP
    // Threshold	95% – 105% FTP
    // VO2 Max	106% – 120% FTP
    // Anaerobic Capacity	> 120% FTP

    hidden function _getZoneInfo(ppx as Number, showAverageWhenPaused as Boolean) as ZoneInfo {
      if (showAverageWhenPaused && mActivityPaused) {
        return new ZoneInfo(0, "Avg. Power", Graphics.COLOR_WHITE,
                            Graphics.COLOR_BLACK, 0, null);
      }

      if (ppx == null || ppx == 0) {
        return new ZoneInfo(0, "Power (" + perSec + "sec)",
                            Graphics.COLOR_WHITE, Graphics.COLOR_BLACK, 0,
                            null);
      }
      var percOfTarget = Utils.percentageOf(ppx, ftp);
      var color = percentageToColor(percOfTarget);
      var color100perc = null;
      if (percOfTarget > 100) {
        color100perc = percentageToColor(100);
      }

      if (percOfTarget <= 54) {
        return new ZoneInfo(1, "Recovery", color, Graphics.COLOR_BLACK,
                            percOfTarget, color100perc);
      }
      if (percOfTarget <= 75) {
        return new ZoneInfo(2, "Endurance", color, Graphics.COLOR_BLACK,
                            percOfTarget, color100perc);
      }
      if (percOfTarget <= 87) {
        return new ZoneInfo(3, "Tempo", color, Graphics.COLOR_BLACK,
                            percOfTarget, color100perc);
      }
      if (percOfTarget <= 94) {
        return new ZoneInfo(3, "Sweet spot", color, Graphics.COLOR_BLACK,
                            percOfTarget, color100perc);
      }
      if (percOfTarget <= 105) {
        return new ZoneInfo(4, "Threshold", color, Graphics.COLOR_BLACK,
                            percOfTarget, color100perc);
      }
      if (percOfTarget <= 120) {
        return new ZoneInfo(5, "VO2 Max", color, Graphics.COLOR_BLACK,
                            percOfTarget, color100perc);
      }
      if (percOfTarget <= 150) {
        return new ZoneInfo(6, "Anaerobic", color, Graphics.COLOR_BLACK,
                            percOfTarget, color100perc);
      }

      return new ZoneInfo(7, "Neuromuscular", color, Graphics.COLOR_BLACK,
                          percOfTarget, color100perc);
    }

   
  }
}