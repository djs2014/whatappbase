import Toybox.Activity;
import Toybox.Lang;
import Toybox.System;
// using WhatAppBase.Types;
module WhatAppBase {
  var gShowInfoMax as Number = 19;
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
    ShowInfoTemperature = 15,  
    ShowInfoEnergyExpenditure = 16,
    ShowInfoPowerPerBodyWeight = 17,
    ShowInfoTestField = 18, // @@ Removed
    ShowInfoPowerVo2Max = 19
    // @@ TODO ShowInfoAscentDescentcombine ascent/descent
  }

  class BaseFactory {
    hidden var mwPower as WhatPower? = null;
    hidden var mwPowerPerWeight as WhatPower? = null;  
    hidden var mwVo2Max as WhatVo2Max? = null;  
    hidden var mwHeartrate as WhatHeartrate? = null;
    hidden var mwCadence as WhatCadence? = null;
    hidden var mwGrade as WhatGrade? = null;
    hidden var mwDistance as WhatDistance? = null;
    hidden var mwAltitude as WhatAltitude? = null;
    hidden var mwSpeed as WhatSpeed? = null;
    hidden var mwPressure as WhatPressure? = null;
    hidden var mwTemperature as WhatTemperature? = null; 
    hidden var mwCalories as WhatCalories? = null;
    hidden var mwTrainingEffect as WhatTrainingEffect? = null;
    hidden var mwTime as WhatTime? = null;
    hidden var mwHeading as WhatHeading? = null;
    hidden var mwEngergyExpenditure as WhatEnergyExpenditure? = null;
    
    hidden var mTop as ShowInfo = ShowInfoNothing;
    hidden var mLeft as ShowInfo = ShowInfoNothing;
    hidden var mRight as ShowInfo = ShowInfoNothing;
    hidden var mBottom as ShowInfo = ShowInfoNothing;

    hidden var mHrFallback as ShowInfo = ShowInfoNothing;
    hidden var mTrainingEffectFallback as ShowInfo = ShowInfoNothing;
    hidden var mPowerFallback as ShowInfo = ShowInfoNothing;

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
    function setPowerFallback(powerFallback as ShowInfo) as Void { mPowerFallback = powerFallback; }
    function setTrainingEffectFallback(trainingEffectFallback as ShowInfo) as Void {      mTrainingEffectFallback = trainingEffectFallback; }

    function getWI_Top() as WhatInformation { return getWI(mTop); }
    function getWI_Left() as WhatInformation { return getWI(mLeft); }
    function getWI_Right() as WhatInformation { return getWI(mRight); }
    function getWI_Bottom() as WhatInformation { return getWI(mBottom); }

    function needSensorData() as Boolean { return isVisible(ShowInfoTemperature); }
    
    function infoSettings() as Void {
      // @@ depricated
      // System.println("mTop[" + mTop + "] mLeft[" + mLeft + "] mRight[" +
      //                mRight + "] mBottom[" + mBottom + "] mHrFallback[" +
      //                mHrFallback + "] mTrainingEffectFallback[" +
      //                mTrainingEffectFallback + "]");
    }

    function getWI(showInfo as ShowInfo) as WhatInformation {
      var instance = _getInstance(showInfo, mHrFallback, mPowerFallback, mTrainingEffectFallback, true);
      if (instance == null) { return null as WhatInformation; }

      var wi = new WhatInformation(instance);
      // Additional overrules
      switch (showInfo) {
        case ShowInfoPowerPerBodyWeight:
          if (wi.getObject() instanceof WhatPower) {
            // zone info is the same
            wi.setCallback(cbFormattedValue, :getPPWFormattedValue);
            wi.setCallback(cbUnits, :getPPWUnits);
            wi.setCallback(cbInfo, :getPPWInfo);
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

    function cleanUp() as Void {
      for (var x = 0; x <= gShowInfoMax; x++) {
        var si = x as ShowInfo;
        if (!isVisible(si)) { 
          System.println("Cleanup WhatInfo: " + si);
          _removeInstance(si);          
        }        
      }        
    } 

    hidden function isVisible(showInfo as ShowInfo) as Boolean {
      return showInfo == mTop || showInfo == mLeft || showInfo == mRight || showInfo == mBottom 
        || showInfo == mHrFallback || showInfo == mTrainingEffectFallback;
    }

    function getPowerInstance() as WhatPower {
       if (mwPower != null) { return mwPower;}
       if (mwPowerPerWeight != null) { return mwPowerPerWeight; }
       //if (mwVo2Max != null) { return mwVo2Max; }
       return null as WhatPower;
    }

    function getSpeedInstance() as WhatSpeed {
       if (mwSpeed != null) { return mwSpeed;}
       return null as WhatSpeed;
    }

    function getTemperatureInstance() as WhatTemperature {
       if (mwTemperature != null) { return mwTemperature;}
       return null as WhatTemperature;
    }

    function getInstance(showInfo as ShowInfo) as WhatInfoBase {
      return _getInstance(showInfo, mHrFallback, mPowerFallback, mTrainingEffectFallback, true);
    }

    function _getInstance(showInfo  as ShowInfo, hrFallback as ShowInfo, powerFallback as ShowInfo, 
                          trainingEffectFallback as ShowInfo, createIfNotExists as Boolean) as WhatInfoBase {      
      switch (showInfo) {
        case ShowInfoPower:
          if (mwPower == null && createIfNotExists) {
            mwPower = new WhatPower();
          }
          if (mInfo != null && mwPower != null) {
            var pwr =  mwPower as WhatPower;
            pwr.updateInfo(mInfo);
            if (!pwr.isAvailable() && powerFallback != ShowInfoNothing) {
              return _getInstance(powerFallback, ShowInfoNothing, ShowInfoNothing, ShowInfoNothing, createIfNotExists);
            }
          }

          return mwPower as WhatInfoBase;

        case ShowInfoHeartrate:
          if (mwHeartrate == null && createIfNotExists) {
            mwHeartrate = new WhatHeartrate();
          }
          if (mInfo != null && mwHeartrate != null) {
            var hr =  mwHeartrate as WhatHeartrate;
            hr.updateInfo(mInfo);
            if (!hr.isAvailable() && hrFallback != ShowInfoNothing) {
              return _getInstance(hrFallback, ShowInfoNothing, ShowInfoNothing, ShowInfoNothing, createIfNotExists);
            }
          }
          return mwHeartrate as WhatInfoBase;

        case ShowInfoSpeed:
          if (mwSpeed == null && createIfNotExists) {
            mwSpeed = new WhatSpeed();
          }
          return mwSpeed as WhatInfoBase;

        case ShowInfoCadence:
          if (mwCadence == null && createIfNotExists) {
            mwCadence = new WhatCadence();
          }
          return mwCadence as WhatInfoBase;

        case ShowInfoAltitude:
          if (mwAltitude == null && createIfNotExists) {
            mwAltitude = new WhatAltitude();
          }
          return mwAltitude as WhatInfoBase;

        case ShowInfoGrade:
          if (mwGrade == null && createIfNotExists) {
            mwGrade = new WhatGrade();
          }
          return mwGrade as WhatInfoBase;

        case ShowInfoHeading:
          if (mwHeading == null && createIfNotExists) {
            mwHeading = new WhatHeading();
          }
          return mwHeading as WhatInfoBase;

        case ShowInfoDistance:
          if (mwDistance == null && createIfNotExists) {
            mwDistance = new WhatDistance();
          }
          return mwDistance as WhatInfoBase;

        case ShowInfoAmbientPressure:
          if (mwPressure == null && createIfNotExists) {
            mwPressure = new WhatPressure();
          }
          return mwPressure as WhatInfoBase;

        case ShowInfoTimeOfDay:
        case ShowInfoElapsedTime:
        case ShowInfoTimer:
          if (mwTime == null && createIfNotExists) {
            mwTime = new WhatTime();
          }
          return mwTime as WhatInfoBase;

        case ShowInfoCalories:
          if (mwCalories == null && createIfNotExists) {
            mwCalories = new WhatCalories();
          }
          return mwCalories as WhatInfoBase;

          //   case ShowInfoTotalDescent:
          //     return new WhatInformation(mwAltitude);
        case ShowInfoTrainingEffect:
          if (mwTrainingEffect == null && createIfNotExists) {
            mwTrainingEffect = new WhatTrainingEffect();
          }

          if (mInfo != null && mwTrainingEffect != null) {
            var te =  mwTrainingEffect as WhatTrainingEffect;
            te.updateInfo(mInfo);
            if (!te.isAvailable() && trainingEffectFallback != ShowInfoNothing) {
              return _getInstance(trainingEffectFallback, ShowInfoNothing, ShowInfoNothing, ShowInfoNothing, createIfNotExists);
            }
          }
          return mwTrainingEffect as WhatInfoBase;

        case ShowInfoTemperature:
          if (mwTemperature == null && createIfNotExists) {
            mwTemperature = new WhatTemperature();
          }
          return mwTemperature as WhatInfoBase;

        case ShowInfoEnergyExpenditure:
          if (mwEngergyExpenditure == null && createIfNotExists) {
            mwEngergyExpenditure = new WhatEnergyExpenditure();
          }
          return mwEngergyExpenditure as WhatInfoBase;

        case ShowInfoPowerPerBodyWeight:
          if (mwPowerPerWeight == null && createIfNotExists) {
            mwPowerPerWeight = new WhatPower();
          }       
          if (mInfo != null && mwPowerPerWeight != null) {
            var pwr =  mwPowerPerWeight as WhatPower;
            pwr.updateInfo(mInfo);
            if (!pwr.isAvailable() && powerFallback != ShowInfoNothing) {
              return _getInstance(powerFallback, ShowInfoNothing, ShowInfoNothing, ShowInfoNothing, createIfNotExists);
            }
          }

          return mwPowerPerWeight as WhatInfoBase;

        case ShowInfoPowerVo2Max:
          if (mwVo2Max == null && createIfNotExists) {
            mwVo2Max = new WhatVo2Max();
          }               
          return mwVo2Max as WhatInfoBase;
       

        case ShowInfoNothing:
          return null as WhatInfoBase;
        default:
          return null as WhatInfoBase;
      }      
    }

    function _removeInstance(showInfo  as ShowInfo) as Void {      
      switch (showInfo) {
        case ShowInfoPower:
          mwPower = null;
          break;

        case ShowInfoHeartrate:
          mwHeartrate = null;
          break;

        case ShowInfoSpeed:
          mwSpeed = null;
          break;

        case ShowInfoCadence:
          mwCadence = null;
          break;

        case ShowInfoAltitude:
          mwAltitude = null;
          break;

        case ShowInfoGrade:
          mwGrade = null;
          break;

        case ShowInfoHeading:
          mwHeading = null;
          break;

        case ShowInfoDistance:
          mwDistance = null;
          break;

        case ShowInfoAmbientPressure:
          mwPressure = null;
          break;

        case ShowInfoTimeOfDay:
        case ShowInfoElapsedTime:
        case ShowInfoTimer:
          // No, not unique
          break;

        case ShowInfoCalories:
          mwCalories = null;
          break;
          
        case ShowInfoTrainingEffect:
          mwTrainingEffect = null;
          break;

        case ShowInfoTemperature:
          mwTemperature = null;
          break;          

        case ShowInfoEnergyExpenditure:
          mwEngergyExpenditure = null;
          break;

        case ShowInfoPowerPerBodyWeight:
          mwPowerPerWeight = null;
          break;

        case ShowInfoPowerVo2Max:
          mwVo2Max = null;
          break;        

        case ShowInfoNothing:
        default:
          break;          
      }
    }

  }
}