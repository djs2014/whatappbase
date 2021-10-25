module WhatAppBase {
import Toybox.Lang;
import Toybox.System;

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
    ShowInfoEnergyExpenditure = 16
  }

  function
  getShowInformation(showInfo, showInfoHrFallback,
                     showInfoTrainingEffectFallback, info as Activity.Info)
      as WhatInformation {
    // System.println("showInfo: " + showInfo);
    switch (showInfo) {
      case ShowInfoPower:
        return new WhatInformation(_wPower.powerPerX(),
                                   _wPower.getAveragePower(),
                                   _wPower.getMaxPower(), _wPower);
      case ShowInfoHeartrate:
        if (info != null) {
          _wHeartrate.updateInfo(info);
        }
        if (!_wHeartrate.isAvailable() &&
            showInfoHrFallback != ShowInfoNothing) {
          return getShowInformation(showInfoHrFallback, ShowInfoNothing,
                                    ShowInfoNothing, null);
        }
        return new WhatInformation(_wHeartrate.getCurrentHeartrate(),
                                   _wHeartrate.getAverageHeartrate(),
                                   _wHeartrate.getMaxHeartrate(), _wHeartrate);
      case ShowInfoSpeed:
        return new WhatInformation(_wSpeed.getCurrentSpeed(),
                                   _wSpeed.getAverageSpeed(),
                                   _wSpeed.getMaxSpeed(), _wSpeed);
      case ShowInfoCadence:
        return new WhatInformation(_wCadence.getCurrentCadence(),
                                   _wCadence.getAverageCadence(),
                                   _wCadence.getMaxCadence(), _wCadence);
      case ShowInfoAltitude:
        return new WhatInformation(_wAltitude.getCurrentAltitude(), 0, 0,
                                   _wAltitude);
      case ShowInfoGrade:
        return new WhatInformation(_wGrade.getGrade(), 0, 0, _wGrade);
      case ShowInfoHeading:
        return new WhatInformation(_wHeading.getCurrentHeading(), 0, 0,
                                   _wHeading);
      case ShowInfoDistance:
        return new WhatInformation(_wDistance.getElapsedDistanceMorKm(), 0, 0,
                                   _wDistance);
      case ShowInfoAmbientPressure:
        return new WhatInformation(_wPowerressure.getPressure(), 0, 0,
                                   _wPowerressure);
      case ShowInfoTimeOfDay:
        return new WhatInformation(_wTime.getTime(), 0, 0, _wTime);
      case ShowInfoCalories:
        return new WhatInformation(_wCalories.getCalories(), 0, 0, _wCalories);
      case ShowInfoTotalAscent:
        return new WhatInformation(_wAltitude.getTotalAscent(), 0, 0,
                                   _wAltitude);
      case ShowInfoTotalDescent:
        return new WhatInformation(_wAltitude.getTotalDescent(), 0, 0,
                                   _wAltitude);
      case ShowInfoTrainingEffect:
        if (info != null) {
          _wTrainingEffect.updateInfo(info);
        }
        if (!_wTrainingEffect.isAvailable() &&
            showInfoTrainingEffectFallback != ShowInfoNothing) {
          return getShowInformation(showInfoTrainingEffectFallback,
                                    ShowInfoNothing, ShowInfoNothing, null);
        }
        return new WhatInformation(_wTrainingEffect.getTrainingEffect(), 0, 0,
                                   _wTrainingEffect);
      case ShowInfoEnergyExpenditure:
        return new WhatInformation(_wEngergyExpenditure.getEnergyExpenditure(),
                                   0, 0, _wEngergyExpenditure);
      case ShowInfoNothing:
      default:
        return null;
    }
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

    function initialize(value, average, max, objInstance as WhatBase) {
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
      }
    }

    function updateInfo(info as Activity.Info) {
      return methodUpdateInfo.invoke(info);
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