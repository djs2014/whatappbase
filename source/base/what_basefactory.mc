import Toybox.Activity;
import Toybox.Lang;
import Toybox.System;
// using WhatAppBase.Types;
module WhatAppBase {
  enum ShowInfo {
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
    ShowInfoElapsedTime = 12,
    ShowInfoTimer = 13,
    ShowInfoTrainingEffect = 14,
    ShowInfoTemperature = 15,  // @@ not working yet
    ShowInfoEnergyExpenditure = 16,
    ShowInfoPowerPerBodyWeight = 17,
    ShowInfoTestField = 18
    // @@ TODO ShowInfoAscentDescentcombine ascent/descent
  }

  class BaseFactory {
    hidden var mwPower as WhatPower? = null;
    hidden var mwPowerPerWeight as WhatPower? = null;  // @@ Needed?
    hidden var mwHeartrate as WhatHeartrate? = null;
    hidden var mwCadence as WhatCadence? = null;
    hidden var mwGrade as WhatGrade? = null;
    hidden var mwDistance as WhatDistance? = null;
    hidden var mwAltitude as WhatAltitude? = null;
    hidden var mwSpeed as WhatSpeed? = null;
    hidden var mwPressure as WhatPressure? = null;
    // hidden var mwTemperature as WhatTemperature; //@@ TODO show current weather in datafield
    hidden var mwCalories as WhatCalories? = null;
    hidden var mwTrainingEffect as WhatTrainingEffect? = null;
    hidden var mwTime as WhatTime? = null;
    hidden var mwHeading as WhatHeading? = null;
    hidden var mwEngergyExpenditure as WhatEnergyExpenditure? = null;
    hidden var mwTestField as WhatTestField? = null;

    hidden var mTop as ShowInfo = ShowInfoNothing;
    hidden var mLeft as ShowInfo = ShowInfoNothing;
    hidden var mRight as ShowInfo = ShowInfoNothing;
    hidden var mBottom as ShowInfo = ShowInfoNothing;

    hidden var mHrFallback as ShowInfo = ShowInfoNothing;
    hidden var mTrainingEffectFallback as ShowInfo = ShowInfoNothing;

    hidden var mInfo as Activity.Info? = null;
    hidden var mDebug as Boolean = false;

    function initialize() {}

    function setDebug(debug as Boolean) as Void { mDebug = debug; }
    function isDebug() as Boolean { return mDebug; }
    function setInfo(info as Activity.Info?) as Void { mInfo = info; }

    function setFields(top as ShowInfo, left as ShowInfo, right as ShowInfo, bottom as ShowInfo) as Void {
      mTop = top;
      mLeft = left;
      mRight = right;
      mBottom = bottom;
    }

    function setHrFallback(hrFallback as ShowInfo) as Void { mHrFallback = hrFallback; }

    function setTrainingEffectFallback(trainingEffectFallback as ShowInfo) as Void {
      mTrainingEffectFallback = trainingEffectFallback;
    }

    function getWI_Top() as WhatInformation { return getWI(mTop); }
    function getWI_Left() as WhatInformation { return getWI(mLeft); }
    function getWI_Right() as WhatInformation { return getWI(mRight); }
    function getWI_Bottom() as WhatInformation { return getWI(mBottom); }

    function infoSettings() as Void {
      // @@ depricated
      // System.println("mTop[" + mTop + "] mLeft[" + mLeft + "] mRight[" +
      //                mRight + "] mBottom[" + mBottom + "] mHrFallback[" +
      //                mHrFallback + "] mTrainingEffectFallback[" +
      //                mTrainingEffectFallback + "]");
    }

    function getWI(showInfo as ShowInfo) as WhatInformation {
      var instance = _getInstance(showInfo, mHrFallback, mTrainingEffectFallback);
      if (instance == null) { return null as WhatInformation; }

      var wi = new WhatInformation(instance);
      // Additional overrules
      switch (showInfo) {
        case ShowInfoPowerPerBodyWeight:
          if (wi.getObject() instanceof WhatPower) {
            // zone info is the same
            wi.setCallback(cbFormattedValue, :getPPWFormattedValue);
            wi.setCallback(cbUnits, :getPPWUnits);
            wi.setCallback(cbLabel, :getPPWLabel);
          }
          break;
        case ShowInfoElapsedTime:
          if (wi.getObject() instanceof WhatTime) {
            wi.setCallback(cbZoneInfo, :getElapsedZoneInfo);
            wi.setCallback(cbFormattedValue, :getElapsedFormattedValue);
            wi.setCallback(cbUnits, :getElapsedUnits);
            wi.setCallback(cbLabel, :getElapsedLabel);
          }
          break;
        case ShowInfoTimer:
          if (wi.getObject() instanceof WhatTime) {
            wi.setCallback(cbZoneInfo, :getTimerZoneInfo);
            wi.setCallback(cbFormattedValue, :getTimerFormattedValue);
            wi.setCallback(cbUnits, :getTimerUnits);
            wi.setCallback(cbLabel, :getTimerLabel);
          }
          break;
        default:
      }

      return wi;
    }

    function getInstance(showInfo as ShowInfo) as WhatInfoBase {
      return _getInstance(showInfo, mHrFallback, mTrainingEffectFallback);
    }

    function _getInstance(showInfo  as ShowInfo, hrFallback  as ShowInfo,
                          trainingEffectFallback as ShowInfo) as WhatInfoBase {      
      switch (showInfo) {
        case ShowInfoPower:
          if (mwPower == null) {
            mwPower = new WhatPower();
          }
          return mwPower;

        case ShowInfoHeartrate:
          if (mwHeartrate == null) {
            mwHeartrate = new WhatHeartrate();
          }
          if (mInfo != null) {
            var hr =  mwHeartrate as WhatHeartrate;
            hr.updateInfo(mInfo);
            if (!hr.isAvailable() && hrFallback != ShowInfoNothing) {
              return _getInstance(hrFallback, ShowInfoNothing, ShowInfoNothing);
            }
          }
          return mwHeartrate;

        case ShowInfoSpeed:
          if (mwSpeed == null) {
            mwSpeed = new WhatSpeed();
          }
          return mwSpeed;

        case ShowInfoCadence:
          if (mwCadence == null) {
            mwCadence = new WhatCadence();
          }
          return mwCadence;

        case ShowInfoAltitude:
          if (mwAltitude == null) {
            mwAltitude = new WhatAltitude();
          }
          return mwAltitude;

        case ShowInfoGrade:
          if (mwGrade == null) {
            mwGrade = new WhatGrade();
          }
          return mwGrade;

        case ShowInfoHeading:
          if (mwHeading == null) {
            mwHeading = new WhatHeading();
          }
          return mwHeading;

        case ShowInfoDistance:
          if (mwDistance == null) {
            mwDistance = new WhatDistance();
          }
          return mwDistance;

        case ShowInfoAmbientPressure:
          if (mwPressure == null) {
            mwPressure = new WhatPressure();
          }
          return mwPressure;

        case ShowInfoTimeOfDay:
        case ShowInfoElapsedTime:
        case ShowInfoTimer:
          if (mwTime == null) {
            mwTime = new WhatTime();
          }
          return mwTime;

        case ShowInfoCalories:
          if (mwCalories == null) {
            mwCalories = new WhatCalories();
          }
          return mwCalories;

          //   case ShowInfoTotalDescent:
          //     return new WhatInformation(mwAltitude);
        case ShowInfoTrainingEffect:
          if (mwTrainingEffect == null) {
            mwTrainingEffect = new WhatTrainingEffect();
          }

          if (mInfo != null) {
            var te =  mwTrainingEffect as WhatTrainingEffect;
            te.updateInfo(mInfo);
            if (!te.isAvailable() && trainingEffectFallback != ShowInfoNothing) {
              return _getInstance(trainingEffectFallback, ShowInfoNothing,
                                  ShowInfoNothing);
            }
          }
          return mwTrainingEffect;

          // case ShowInfoTemperature:
          //   if (mwTemperature == null) {
          //     mwTemperature = new WhatTemperature();
          //   }
          //   return mwTemperature;

        case ShowInfoEnergyExpenditure:
          if (mwEngergyExpenditure == null) {
            mwEngergyExpenditure = new WhatEnergyExpenditure();
          }
          return mwEngergyExpenditure;

        case ShowInfoPowerPerBodyWeight:
          if (mwPowerPerWeight == null) {
            mwPowerPerWeight = new WhatPower();
          }
          return mwPowerPerWeight;

        case ShowInfoTestField:
          if (mwTestField == null) {
            mwTestField = new WhatTestField();
          }
          return mwTestField;

        case ShowInfoNothing:
        default:
          return null as WhatInfoBase;
      }
    }
  }
}