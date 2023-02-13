import Toybox.Activity;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time;
import Toybox.Graphics;

module WhatAppBase {
  class WhatTemperature extends WhatInfoBase {
      // min, max, avg temp
      // + ++ - -- 
      // comfort zones
    var temperature as Float?;
    var targetTemperature as Number = 20;

    // @@ sensor obj
    var whatApp as WhatApp;
    function initialize() { WhatInfoBase.initialize();
      whatApp = WhatAppBase.WhatApp.instance();
     }

    function setTargetTemperature(temperature as Number) as Void { self.targetTemperature = temperature; }

    function updateInfo(info as Activity.Info) as Void {
      //
    }

    function setTemperature(temperature as Float?) as Void {
      self.temperature = temperature;
    }

    function getZoneInfo() as ZoneInfo { return _getZoneInfo(getTemperature()); }
    function getValue() as WhatValue { return convertToMetricOrStatute(getTemperature()); }
    function getFormattedValue() as String { 
      if (temperature == null) { return "--"; }
      return convertToMetricOrStatute(getTemperature()).format(getFormatString()); 
    }
    function getUnits() as String { 
      if (mDevSettings.temperatureUnits == System.UNIT_STATUTE) { return "°F"; }
      return "°C"; 
    } 
    function getLabel() as String {   
      return "Temperature";
    }

    function getTemperature() as Float {
        if (temperature == null) { return 0.0f;}
        return temperature as Float;
    }

    hidden function convertToMetricOrStatute(value as Numeric) as Numeric {
      if (mDevSettings.temperatureUnits == System.UNIT_STATUTE) {
        value = Utils.celciusToFarenheit(value);
      }
      return value;
    }

    hidden function getFormatString() as String {
      switch (mFieldType) {
        case Types.OneField:
        case Types.WideField:
          return "%.2f";
        case Types.SmallField:
          return "%.1f";
        default:
          return "%.1f";
      }      
    }

     hidden function _getZoneInfo(temperature as Float?) as ZoneInfo {
      if (temperature == null || temperature == 0) {
        return new ZoneInfo(0, "Temperature", Graphics.COLOR_WHITE,
                            Graphics.COLOR_BLACK, 0, null);
      }
      
      var percOfTarget = Utils.percentageOf(temperature, targetTemperature);
      var color = percentageToColor(percOfTarget);
      var color100perc = null;
      if (percOfTarget > 100) {
        color100perc = percentageToColor(100);
      }

      return new ZoneInfo(0, "Temperature", color, Graphics.COLOR_BLACK, percOfTarget, color100perc);
    }
  }
}