import Toybox.Activity;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Graphics;
import Toybox.AntPlus;
using Toybox.UserProfile;
module WhatAppBase {

  // ( : Info) module Info {
  
  class WhatPower extends WhatInfoBase {
    hidden var perSec as Number = 3;
    hidden var ftp as Number = 250;
    hidden var dataPerSec as Array = [];

    hidden var averagePower as Number = 0;
    hidden var maxPower as Number = 0 ;
    hidden var userWeightKg as Float = 0.0f;

    hidden var lastCheck as Number = 0;
    hidden const SECONDS_TO_FALLBACK = 60;
    hidden var counterToFallback as Number = SECONDS_TO_FALLBACK;

    hidden var bikePower as AntPlus.BikePower;
    hidden var listener as ABikePowerListener;
    hidden var mPowerBalanceLeft as Number = 0;
    hidden var mPowerBalanceRight as Number = 0;  
    hidden var ticks as Number = 0;
    hidden var avgPowerBalanceLeft as Double = 0.0d;  

    function initialize() { 
      WhatInfoBase.initialize();
      listener = new ABikePowerListener(self.weak(), :onPedalPowerBalanceUpdate);
      bikePower = new AntPlus.BikePower(listener);        
      }

    function initWeight() as Void {
      var profile = UserProfile.getProfile();
      userWeightKg = 0.0f;
      if (profile.weight == null) { return; }
      var weight = profile.weight as Float;
      userWeightKg = weight / 1000.0;
    }

    function setFtp(ftp as Number) as Void { self.ftp = ftp; }
    function setPerSec(perSec as Number) as Void { self.perSec = perSec; }
   
    // Must be called once per second
    function updateInfo(info as Activity.Info) as Void {
      mAvailable = false;
      mActivityPaused = activityIsPaused(info);
      var activityStarted = activityIsStarted(info);
      var power = 0;

      if (info has :currentPower) {
        mAvailable = true;
        if (info.currentPower != null) {
          power = info.currentPower as Number;
          counterToFallback = SECONDS_TO_FALLBACK;
        } else if (activityStarted && !mActivityPaused) {
          // When activity not paused and no power for x seconds
          if (counterToFallback < 0) {
            mAvailable = false;
          } else {
            counterToFallback = counterToFallback - 1;
            System.println("Power fallback: " + counterToFallback);
          }
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

      if (power > 0 && mPowerBalanceLeft != null && mPowerBalanceLeft > 0) {
        ticks = ticks + 1;
        var a = 1 / ticks.toDouble();
        var b = 1 - a;
        avgPowerBalanceLeft = (a * mPowerBalanceLeft) + b * avgPowerBalanceLeft;
      }
      
    }

    function onPedalPowerBalanceUpdate(pedalPowerPercent as Lang.Number, rightPedalIndicator as Lang.Boolean) as Void {
        if (rightPedalIndicator) {
            mPowerBalanceLeft = (100 - pedalPowerPercent);
            mPowerBalanceRight = pedalPowerPercent;
        } else {
            mPowerBalanceLeft = pedalPowerPercent;
            mPowerBalanceRight = (100 - pedalPowerPercent);
        }
    }

    function getZoneInfo() as ZoneInfo { return _getZoneInfo(powerPerX(), true); }
    function getValue() as WhatValue { return powerPerX(); }
    function getFormattedValue() as String {
      return powerPerX().format("%.0f");
    }
    function getUnits() as String { return "w"; }    
    function getInfo() as String { return _getPowerBalanceString("w"); }    
    function getLabel() as String { return "Power (" + perSec + "sec)"; }

    function getAltZoneInfo() as ZoneInfo {
      return _getZoneInfo(getAveragePower(), false);
    }
    function getAltValue() as WhatValue { return getAveragePower(); }
    function getAltFormattedValue() as String {
      return getAveragePower().format("%.0f");
    }
    function getAltUnits() as String { return "w"; }
    function getAltInfo() as String { return _getPowerBalanceString("w"); }    
    function getAltLabel() as String { return "Avg power"; }

    function getMaxValue() as WhatValue { return getMaxPower(); }
    function getMaxZoneInfo() as ZoneInfo {
      return _getZoneInfo(getMaxPower(), false);
    }

    // Power per weight
    // function getPPWZoneInfo() as ZoneInfo {
    //   return _getZoneInfo(powerPerX()); 
    // }
    function getPPWValue() as Number {
      return convertToMetricOrStatute(powerPerWeight());
    }
    function getPPWFormattedValue() as String {
      return convertToMetricOrStatute(powerPerWeight()).format("%.1f");
    }
    function getPPWUnits() as String {
      var units = "w/kg";
      if (mDevSettings.weightUnits == System.UNIT_STATUTE) {
        units = "w/lbs";  // watt per pounds
      }
      return units;
    }
    function getPPWInfo() as String {
      var units = "w/kg";
      if (mDevSettings.weightUnits == System.UNIT_STATUTE) {
        units = "w/lbs";  // watt per pounds
      }
      return _getPowerBalanceString(units);
    }
    function getPPWLabel() as String {
      if (mDevSettings.weightUnits == System.UNIT_STATUTE) {
        return "Avg power/lbs";
      } else {
        return "Avg power/kg";
      }
    }
        
    //

    function _getPowerBalanceString(units as String) as String { 
      if (mActivityPaused && avgPowerBalanceLeft > 0) {
        var avgLeft = avgPowerBalanceLeft.toNumber();
        return avgLeft.format("%d") + " " + units + " " + (100-avgLeft).format("%d");
      }
      if (mPowerBalanceLeft>0 && mPowerBalanceRight>0) {
        return mPowerBalanceLeft.format("%d") + " " + units + " " + mPowerBalanceRight.format("%d");
      } 
      return units;
    } 

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