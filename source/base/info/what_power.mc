import Toybox.Activity;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Graphics;
using Toybox.UserProfile;
module WhatAppBase {
  // ( : Info) module Info {
  class WhatPower extends WhatInfoBase {
    hidden var perSec = 3 as Lang.Number;
    hidden var ftp = 250 as Lang.Number;
    hidden var dataPerSec = [] as Lang.Array<Lang.Number>;

    hidden var averagePower = 0 as Lang.Number;
    hidden var maxPower = 0 as Lang.Number;
    hidden var userWeightKg = 0.0f;

    hidden var lastCheck = 0 as Lang.Number;

    function initialize() { WhatInfoBase.initialize(); }

    function initWeight() as Void {
      var profile = UserProfile.getProfile();
      userWeightKg = profile.weight / 1000.0;
    }

    function setFtp(ftp as Lang.Number) { self.ftp = ftp; }
    function setPerSec(perSec as Lang.Number) { self.perSec = perSec; }

    // Must be called once per second
    function updateInfo(info as Activity.Info) {
      mAvailable = false;
      mActivityPaused = activityIsPaused(info);

      if (info has : currentPower) {
        mAvailable = true;
        var power = 0;
        if (info.currentPower) {
          power = info.currentPower;
        }
        if (ensureXSecondsPassed(lastCheck, 1)) {
          lastCheck = Time.now().value();
          System.println("Add power: " + lastCheck);
          addPower(power);
        }
      }

      if (info has : averagePower) {
        if (info.averagePower) {
          averagePower = info.averagePower;
        } else {
          averagePower = 0.0f;
        }
      }

      if (info has : maxPower) {
        if (info.maxPower) {
          maxPower = info.maxPower;
        }
      }
    }

    function getZoneInfo() as ZoneInfo { return _getZoneInfo(powerPerX()); }
    function getValue() { return powerPerX(); }
    function getFormattedValue() as Lang.String {
      return powerPerX().format("%.0f");
    }
    function getUnits() as String { return "w"; }
    function getLabel() as Lang.String { return "Power (" + perSec + "sec)"; }

    function getAltZoneInfo() as ZoneInfo {
      return _getZoneInfo(getAveragePower());
    }
    function getAltValue() { return getAveragePower(); }
    function getAltFormattedValue() as Lang.String {
      return getAveragePower().format("%.0f");
    }
    function getAltUnits() as String { return "w"; }
    function getAltLabel() as Lang.String { return "Avg power"; }

    // Power per weight
    // function getPPWZoneInfo() as ZoneInfo {
    //   return _getZoneInfo(powerPerX());
    // }
    function getPPWValue() {
      return convertToMetricOrStatute(powerPerWeight());
    }
    function getPPWFormattedValue() as Lang.String {
      return convertToMetricOrStatute(powerPerWeight()).format("%.1f");
    }
    function getPPWUnits() as String {
      if (mDevSettings.weightUnits == System.UNIT_STATUTE) {
        return "w/lbs";  // watt per pounds
      } else {
        return "w/kg";
      }
    }
    function getPPWLabel() as Lang.String {
      if (mDevSettings.weightUnits == System.UNIT_STATUTE) {
        return "Avg power/lbs";
      } else {
        return "Avg power/kg";
      }
    }

    // --

    hidden function convertToMetricOrStatute(value) {
      if (mDevSettings.weightUnits == System.UNIT_STATUTE) {
        value = Utils.kilogramToLbs(value);
      }
      return value;
    }
    hidden function getAveragePower() as Lang.Number {
      if (averagePower == null) {
        return 0;
      }
      return self.averagePower;
    }

    hidden function getMaxPower() as Lang.Number {
      if (maxPower == null) {
        return 0;
      }
      return self.maxPower;
    }

    hidden function addPower(power) {
      // var dataPerSec = powerDataPerSecond as Lang.Array<Lang.Number>;
      if (dataPerSec.size() >= perSec) {
        dataPerSec = dataPerSec.slice(1, perSec);
      }

      dataPerSec.add(power);
    }

    hidden function powerPerX() as Lang.Number {
      if (mActivityPaused) {
        return getAveragePower();
      }

      var perSec = dataPerSec as Lang.Array<Lang.Number>;
      if (perSec.size() == 0) {
        return 0;
      }

      var ppx = 0;
      for (var x = 0; x < perSec.size(); x++) {
        ppx = ppx + perSec[x];
      }
      return ppx / perSec.size();
    }

    hidden function powerPerWeight() as Lang.Float {
      if (mActivityPaused) {
        return averagePowerPerWeight();
      }
      if (userWeightKg == 0) {
        return 0.0f;
      }
      return powerPerX() / userWeightKg.toFloat();
    }

    hidden function averagePowerPerWeight() as Lang.Float {
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

    hidden function _getZoneInfo(ppx) as ZoneInfo {
      if (mActivityPaused) {
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