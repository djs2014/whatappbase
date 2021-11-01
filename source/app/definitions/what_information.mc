module WhatAppBase {
import Toybox.Lang;
import Toybox.System;
import Toybox.Activity;

  enum {
    ShowInfoNothing = 0,
    ShowInfoPower = 1,
    ShowInfoHeartrate = 2,
    ShowInfoSpeed = 3,
    ShowInfoCadence = 4,
    ShowInfoAltitude = 5,
    ShowInfoGrade = 6,
    ShowInfoHeading = 7,
    ShowInfoDistance = 8,
    ShowInfoAmbientPressure = 9,
    ShowInfoTimeOfDay = 10,
    ShowInfoCalories = 11,
    ShowInfoTotalAscent = 12,   // @@ TODO combine ascent/descent
    ShowInfoTotalDescent = 13,  // @@ TODO combine ascent/descent
    ShowInfoTrainingEffect = 14,
    ShowInfoTemperature = 15,  // @@ not working yet
    ShowInfoEnergyExpenditure = 16,
    ShowInfoPowerPerBodyWeight = 17, // @@ TODO
    ShowInfoTestField = 18  
  }

  class WhatInformation {
    var value = 0.0f;
    var average = 0.0f;
    var max = 0.0f;
    var objInstance = null;

    var methodUpdateInfo;
    var methodGetZoneInfo;
    var methodGetUnits;
    var methodConvertToDisplayFormat;
    var methodIsLabelHidden;

    function initialize(value, average, max, objInstance as WhatInfoBase) {
      self.value = value;
      self.average = average;
      self.max = max;
      self.objInstance = objInstance;
      if (objInstance != null) {
        methodUpdateInfo = new Lang.Method(self.objInstance, : updateInfo);
        methodGetZoneInfo = new Lang.Method(self.objInstance, : getZoneInfo);
        methodGetUnits = new Lang.Method(self.objInstance, : getUnits);
        methodConvertToDisplayFormat =
            new Lang.Method(self.objInstance,
                            : convertToDisplayFormat);
        methodIsLabelHidden = new Lang.Method(self.objInstance, : isLabelHidden);
      }
    }

    function updateInfo(info as Activity.Info) {
      return methodUpdateInfo.invoke(info);
    }

    function isLabelHidden() as Lang.Boolean {
      return methodIsLabelHidden.invoke();
    }

    function zoneInfoValue() as ZoneInfo {
      return methodGetZoneInfo.invoke(value);
    }

    function zoneInfoAverage() as ZoneInfo {
      return methodGetZoneInfo.invoke(average);
    }
    function zoneInfoMax() as ZoneInfo { return methodGetZoneInfo.invoke(max); }

    function units() as String { return methodGetUnits.invoke(); }

    function formattedValue(fieldType) as String {
      // Convert value to correct unit
      return methodConvertToDisplayFormat.invoke(value, fieldType);
    }
  }
}