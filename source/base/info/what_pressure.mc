import Toybox.Activity;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time;
import Toybox.Graphics;
// using WhatAppBase.Colors;
// using Toybox.SensorHistory;
module WhatAppBase {
  class WhatPressure extends WhatInfoBase {
    hidden var perMin as Number = 30;
    hidden var dataOneMin as Array = [];
    hidden var dataPerMin as Array = [];
    hidden var fastPressureDropPerMin as Float = 0.1877f;

    // in km
    hidden var ambientPressure as Float = 0.0f;
    hidden var meanSeaLevelPressure as Float = 0.0f;
    hidden var showSeaLevelPressure as Boolean = false;

    hidden var lastCheck as Number = 0;

    function initialize() { WhatInfoBase.initialize(); }

    function setPerMin(perMin as Number) as Void { self.perMin = perMin; }
    function reset() as Void { dataPerMin = []; }
    function setShowSeaLevelPressure(showSeaLevelPressure as Boolean) as Void {
      self.showSeaLevelPressure = showSeaLevelPressure;
    }
    function isSeaLevelPressure() as Boolean { return showSeaLevelPressure; }

    function updateInfo(info as Activity.Info) as Void {
      if (info has :ambientPressure) {
        mAvailable = true;
        if (info.ambientPressure != null) {
          self.ambientPressure = Utils.pascalToMilliBar(info.ambientPressure);
        } else {
          self.ambientPressure = 0.0f;
        }
      }

      if (info has :meanSeaLevelPressure) {
        if (info.meanSeaLevelPressure != null) {
          self.meanSeaLevelPressure =
              Utils.pascalToMilliBar(info.meanSeaLevelPressure);
        } else {
          self.meanSeaLevelPressure = 0.0f;
        }

        if (Utils.ensureXSecondsPassed(lastCheck, 1)) {
          lastCheck = Time.now().value();
          System.println("addPressurePerSec: " + lastCheck);
          addPressurePerSec(meanSeaLevelPressure);
        }
      }
    }

    function getZoneInfo() as ZoneInfo { return _getZoneInfo(getPressure()); }
    function getValue() as WhatValue { return getPressure(); }
    function getFormattedValue() as String { return getPressure().format(getFormatString()); }
    function getUnits() as String { return "hPa"; }
    function getLabel() as String {
      if (showSeaLevelPressure) {
        return "Sealevel";
      }
      return "Location";
    }

    // --
    hidden function addPressurePerSec(pressure as Float) as Void {
      if (pressure == 0.0f) {
        return;
      }

      if (dataOneMin.size() >= 60) {
        var avgPressurePerMin = getAvgPressureOneMin();
        addPressurePerMin(avgPressurePerMin);
        dataOneMin = [];
      }

      dataOneMin.add(pressure);
    }

    hidden function addPressurePerMin(avgPressurePerMin as Float) as Void {
      if (dataPerMin.size() >= perMin) {
        dataPerMin = dataPerMin.slice(1, perMin);
      }

      dataPerMin.add(avgPressurePerMin);
    }

    hidden function getAvgPressureOneMin() as Float {
      if (dataOneMin.size() == 0) {
        return 0.0f;
      }

      var oneMin = dataOneMin as Array<Float>;
      var ppx = 0.0f;
      for (var x = 0; x < oneMin.size(); x++) {
        ppx = ppx + oneMin[x];
      }
      return ppx / oneMin.size();
    }

    hidden function pressurePerMinX() as Float {
      if (dataPerMin.size() == 0) {
        return 0.0f;
      }

      var perMin = dataPerMin as Array<Float>;
      var ppx = 0.0f;
      for (var x = 0; x < perMin.size(); x++) {
        ppx = ppx + perMin[x];
      }
      return ppx / perMin.size();
    }

    // on location or at sea level
    hidden function getPressure() as Float {
      if (showSeaLevelPressure) {
        return getSeaLevelPressure();
      } else {
        return getAmbientPressure();
      }
    }

    // on location
    hidden function getAmbientPressure() as Float {
      if (ambientPressure == null) {
        return 0.0f;
      }
      return ambientPressure;
    }

    // at sealevel
    hidden function getSeaLevelPressure() as Float {
      if (meanSeaLevelPressure == null) {
        return 0.0f;
      }
      return meanSeaLevelPressure;
    }

    hidden function getFormatString() as String {
      switch (mFieldType) {
        case Types.OneField:
        case Types.WideField:
          return "%.2f";
        case Types.SmallField:
          return "%.0f";
        default:
          return "%.0f";
      }      
    }

    // Create a method to get the SensorHistoryIterator object
    // hidden function getIterator() {
    //   // var oneHour = new Time.Duration(3600);

    //   // Check device for SensorHistory compatibility
    //   if ((Toybox has
    //        : SensorHistory) &&
    //       (Toybox.SensorHistory has
    //        : getPressureHistory)) {
    //     return Toybox.SensorHistory.getPressureHistory(
    //         {});  // {"period" => oneHour, "order" => null}
    //   }
    //   // System.println("no SensorHistory");
    //   return null;
    // }

    //  https://www.thoughtco.com/how-to-read-a-barometer-3444043 (sealevel)
    // High > 1022.689
    // Rising or steady pressure means continued fair weather.
    // Slowly falling pressure means fair weather.
    // Rapidly falling pressure means cloudy and warmer conditions.

    // Normal 1022.689–1009.144 mb
    // Rising or steady pressure means present conditions will continue.
    // Slowly falling pressure means little change in the weather.
    // Rapidly falling pressure means that rain is likely, or snow if it is cold
    // enough. Precipitation likely

    // Low < 1009.144 mb
    // Rising or steady pressure indicates clearing and cooler weather.
    // Slowly falling pressure indicates rain. Precipitation
    // Rapidly falling pressure indicates a storm is coming.

    // @@ get pressure history
    // get from last 10 minutes / 30 minutes == setting
    // calc. amount up/down

    // Barometric pressure often is measured in inches of mercury, or in-Hg. If
    // barometric pressure rises or falls more than 0.18 in-Hg in less than
    // three hours,
    //  barometric pressure is said to be changing rapidly. ... A change of less
    //  than 0.003 in-Hg in less than three hours is considered to be holding
    //  steady.
    // 1Hg = 33.86389 mBar
    // ~ 33.8 / 60 / 3 == 0.1877 per minute avg
    hidden function getTrendLevel(diffInMbar as Float) as String {
      // @@ ?? convert to avg measure period
      // System.println("Diff in mBar: " + diffInMbar);

      if (diffInMbar <= -1 * fastPressureDropPerMin) {
        return "--";
      }
      if (diffInMbar < -0.5 * fastPressureDropPerMin) {
        return "-";
      }
      if (diffInMbar < 0.5 * fastPressureDropPerMin) {
        return "";
      }
      if (diffInMbar < fastPressureDropPerMin) {
        return "+";
      }
      return "++";
    }

    hidden function _getZoneInfo(pressure as Float) as ZoneInfo {
      if (pressure == null || pressure == 0) {
        return new ZoneInfo(0, getLabel(), Graphics.COLOR_WHITE,
                            Graphics.COLOR_BLACK, 0, null);
      }

      var sealevel = "";
      if (showSeaLevelPressure) { sealevel = "~"; }
            
      // calc trend
      var avg = pressurePerMinX();
      if (avg == 0) {
        avg = getAvgPressureOneMin();
        if (avg == 0) {
          avg = meanSeaLevelPressure;
        }
      }

      var diff = meanSeaLevelPressure - avg;
      var trend = getTrendLevel(diff);
      if (trend.length() > 0) {
        trend = " " + trend;
      }

      var color = getPressureColor(pressure);
      
      if (pressure < 1009.144) {
        return new ZoneInfo(1, sealevel + "Low" + trend, color, Graphics.COLOR_BLACK, 100,
                            null);
      }
      if (pressure < 1022.689) {
        return new ZoneInfo(2, sealevel + "Normal" + trend, color, Graphics.COLOR_BLACK, 100,
                            null);
      }
      return new ZoneInfo(3, sealevel + "High" + trend, color, Graphics.COLOR_BLACK, 100,
                          null);
    }

    hidden function getPressureColor(pressure as Float) as ColorType {
      if (pressure < 960) {
        return Colors.COLOR_WHITE_DK_PURPLE_3;
      }
      if (pressure < 970) {
        return Colors.COLOR_WHITE_PURPLE_3;
      }
      if (pressure < 980) {
        return Colors.COLOR_WHITE_DK_BLUE_3;
      }
      if (pressure < 990) {
        return Colors.COLOR_WHITE_BLUE_3;
      }
      if (pressure < 1000) {
        return Colors.COLOR_WHITE_LT_GREEN_3;
      }
      if (pressure < 1010) {
        return Colors.COLOR_WHITE_GREEN_3;
      }
      if (pressure < 1020) {
        return Colors.COLOR_WHITE_YELLOW_3;
      }
      if (pressure < 1030) {
        return Colors.COLOR_WHITE_ORANGE_3;
      }
      if (pressure < 1040) {
        return Colors.COLOR_WHITE_ORANGERED_3;
      }
      if (pressure < 1050) {
        return Colors.COLOR_WHITE_ORANGERED2_3;
      }

      return Colors.COLOR_WHITE_RED_3;
    }
  }
}