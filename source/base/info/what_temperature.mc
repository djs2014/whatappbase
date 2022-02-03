using Toybox.UserProfile;
import Toybox.Lang;
import Toybox.System;
import Toybox.Activity;
import Toybox.Time;
using Toybox.Background;

module WhatAppBase {
  class WhatTemperature extends WhatInfoBase {
    // hidden var currentTemperature as Number = 0;
    // hidden var avarageTemperature as Number  = 0;
    // hidden var maxTemperature as Number  = 0;
    // hidden var TemperatureZones as Array<Lang.Number>?;
    hidden var BGActive as Boolean = false;

    function initialize() { WhatInfoBase.initialize(); }
   
    function updateInfo(info as Activity.Info) as Void {
      mAvailable = true;      
    }

    
    function getValue() as WhatValue { return getCurrentTemperature(); }
    function getFormattedValue() as String { 
      var temperature = getCurrentTemperature();
      if (temperature == null) { return "--"; }
      return temperature.format("%.1f"); 
    }
    function getUnits() as String { return "C"; }
    function getLabel() as String { return "Temperature"; }

    // function getAltZoneInfo() as ZoneInfo { return _getZoneInfo(getAverageHeartrate()); }
    // function getAltValue() as WhatValue { return getAverageHeartrate(); }
    // function getAltFormattedValue() as String { return getAverageHeartrate().format("%.0f"); }
    // function getAltUnits() as String { return "bpm"; }
    // function getAltLabel() as String { return "Avg heartrate"; }

    // function getMaxValue() as WhatValue { return getMaxHeartrate(); }
    // function getMaxZoneInfo() as ZoneInfo { return _getZoneInfo(getMaxHeartrate()); }

    // --
    

    hidden function getCurrentTemperature() as Number? {      
      return Application.Storage.getValue("Temperature");
    }

    function stopBGservice() as Void {
        // if (!BGActive) { return; }
        try {
            Background.deleteTemporalEvent();
            BGActive = false;            
        } catch (ex) {
            ex.printStackTrace();            
            BGActive = false;
        } 
    }

    function startBGservice(duration as Time.Duration) as Void {              
        try {
            if (Toybox.System has :ServiceDelegate) {
                Background.registerForTemporalEvent(duration);
                BGActive = true;                
            } else {
                System.println("Unable to start BGservice (no registerForTemporalEvent)");
                BGActive = false;                
            }
        } catch (ex) {
            ex.printStackTrace();
            BGActive = false;
        } 
    }

    // hidden function convertToMetricOrStatute(value as Float) as Float {
    //   if (mDevSettings.distanceUnits == System.UNIT_STATUTE) {
    //     value = Utils.kilometerToMile(value);
    //   }
    //   return value;
    // }

    function _getZoneInfo(hr as Number) as ZoneInfo {
      
      return new ZoneInfo(0, "Temperature", Graphics.COLOR_WHITE,
                            Graphics.COLOR_BLACK, 0, null);
      

      // var percOfTarget = Utils.percentageOf(hr, hrZones[5]);
      // var color = percentageToColor(percOfTarget);
      // var color100perc = null;
      // if (percOfTarget > 100) {
      //   color100perc = percentageToColor(100);
      // }

      // if (hr < hrZones[1]) {
      //   return new ZoneInfo(1, "Very light", color, Graphics.COLOR_BLACK,
      //                       percOfTarget, color100perc);
      // }
      // if (hr < hrZones[2]) {
      //   return new ZoneInfo(2, "Light", color, Graphics.COLOR_BLACK,
      //                       percOfTarget, color100perc);
      // }
      // if (hr < hrZones[3]) {
      //   return new ZoneInfo(3, "Moderate", color, Graphics.COLOR_BLACK,
      //                       percOfTarget, color100perc);
      // }
      // if (hr < hrZones[4]) {
      //   return new ZoneInfo(4, "Hard", color, Graphics.COLOR_BLACK,
      //                       percOfTarget, color100perc);
      // }
      // if (hr < hrZones[5]) {
      //   return new ZoneInfo(5, "Maximum", color, Graphics.COLOR_BLACK,
      //                       percOfTarget, color100perc);
      // }

      // return new ZoneInfo(6, "Extreme", color, Graphics.COLOR_BLACK,
      //                     percOfTarget, color100perc);
    }
  }
}