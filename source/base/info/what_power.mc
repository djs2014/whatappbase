import Toybox.Activity;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Graphics;
module WhatAppBase {
  // ( : Info) module Info {
    class WhatPower extends WhatInfoBase {
      hidden var perSec = 3 as Lang.Number;
      hidden var ftp = 250 as Lang.Number;
      hidden var dataPerSec = [] as Lang.Array<Lang.Number>;

      hidden var averagePower = 0 as Lang.Number;
      hidden var maxPower = 0 as Lang.Number;

      function initialize() { WhatInfoBase.initialize(); }

      function setFtp(ftp as Lang.Number) { self.ftp = ftp; }
      function setPerSec(perSec as Lang.Number) { self.perSec = perSec; }

      function getAveragePower() as Lang.Number {
        if (averagePower == null) {
          return 0;
        }
        return self.averagePower;
      }

      function getMaxPower() as Lang.Number {
        if (maxPower == null) {
          return 0;
        }
        return self.maxPower;
      }

      // called once per second
      function updateInfo(info as Activity.Info) {
        available = false;
        activityPaused = activityIsPaused(info);

        if (info has : currentPower) {
          available = true;
          var power = 0;
          if (info.currentPower) {
            power = info.currentPower;
          }
          addPower(power);
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

      hidden function addPower(power) {
        // var dataPerSec = powerDataPerSecond as Lang.Array<Lang.Number>;
        if (dataPerSec.size() >= perSec) {
          dataPerSec = dataPerSec.slice(1, perSec);
        }

        dataPerSec.add(power);
      }

      function powerPerX() as Lang.Number {
        if (activityPaused) {
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

      function getUnitsLong() { return perSec + "sec"; }

      function getUnits() as String { return "w"; }

      // https://www.trainerroad.com/blog/cycling-power-zones-training-zones-explained/
      // https://theprologue.wayneparkerkent.com/how-do-you-train-for-cycling-based-on-power-zones/
      // Active Recovery	<= 54% FTP
      // Endurance	55% – 75% FTP
      // Tempo	76% – 87% FTP
      // Sweet Spot	88% – 94% FTP
      // Threshold	95% – 105% FTP
      // VO2 Max	106% – 120% FTP
      // Anaerobic Capacity	> 120% FTP

      function getZoneInfo(ppx) as ZoneInfo {
        if (activityPaused) {
          return new ZoneInfo(0, "Avg. Power", Graphics.COLOR_WHITE,
                              Graphics.COLOR_BLACK, 0, null);
        }

        if (ppx == null || ppx == 0) {
          return new ZoneInfo(0, "Power (" + getUnitsLong() + ")",
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
// }