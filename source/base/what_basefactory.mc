import Toybox.Activity;
import Toybox.Lang;
import Toybox.System;
// using WhatAppBase.Types;
module WhatAppBase {

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
    ShowInfoPowerPerBodyWeight = 17,  // @@ TODO
    ShowInfoTestField = 18
  }

  class BaseFactory {
    hidden var mwPower = null as WhatPower;
    hidden var mwPowerPerWeight = null as WhatPower;  // @@ Needed?
    hidden var mwHeartrate = null as WhatHeartrate;
    hidden var mwCadence = null as WhatCadence;
    hidden var mwGrade = null as WhatGrade;
    hidden var mwDistance = null as WhatDistance;
    hidden var mwAltitude = null as WhatAltitude;
    hidden var mwSpeed = null as WhatSpeed;
    hidden var mwPressure = null as WhatPressure;
    // hidden var mwTemperature = null as WhatTemperature; //@@ show current weather
    hidden var mwCalories = null as WhatCalories;
    hidden var mwTrainingEffect = null as WhatTrainingEffect;
    hidden var mwTime = null as WhatTime;
    hidden var mwHeading = null as WhatHeading;
    hidden var mwEngergyExpenditure = null as WhatEnergyExpenditure;
    hidden var mwTestField = null as WhatTestField;

    hidden var mTop = ShowInfoNothing;
    hidden var mLeft = ShowInfoNothing;
    hidden var mRight = ShowInfoNothing;
    hidden var mBottom = ShowInfoNothing;

    hidden var mHrFallback = ShowInfoNothing;
    hidden var mTrainingEffectFallback = ShowInfoNothing;

    hidden var mInfo = null as Activity.Info;
    hidden var mDebug = false;
    function initialize() {}

    function setDebug(debug as Lang.Boolean) { mDebug = debug; }
    function isDebug() { return mDebug; }
    function setInfo(info as Activity.Info) { mInfo = info; }

    function setFields(top, left, right, bottom) {
      mTop = top;
      mLeft = left;
      mRight = right;
      mBottom = bottom;
    }

    function setHrFallback(hrFallback) { mHrFallback = hrFallback; }

    function setTrainingEffectFallback(trainingEffectFallback) {
      mTrainingEffectFallback = trainingEffectFallback;
    }

    function getWI_Top() as WhatInformation { return getWI(mTop); }
    function getWI_Left() as WhatInformation { return getWI(mLeft); }
    function getWI_Right() as WhatInformation { return getWI(mRight); }
    function getWI_Bottom() as WhatInformation { return getWI(mBottom); }

    function infoSettings() as Void {
      System.println("mTop[" + mTop + "] mLeft[" + mLeft + "] mRight[" +
                     mRight + "] mBottom[" + mBottom + "] mHrFallback[" +
                     mHrFallback + "] mTrainingEffectFallback[" +
                     mTrainingEffectFallback + "]");
    }

    function getWI(showInfo) as WhatInformation {
      var instance =
          _getInstance(showInfo, mHrFallback, mTrainingEffectFallback);
      if (instance == null) {
        // var nope = null as WhatInformation;
        return null as WhatInformation;
      }
      var wi = new WhatInformation(instance);
      // Additional overrules
      switch (showInfo) {
        case ShowInfoPowerPerBodyWeight:
          if (wi.getObject() instanceof WhatPower) {
            // zone info is the same
            wi.setCallback(cbFormattedValue, : getPPWFormattedValue);
            wi.setCallback(cbUnits, : getPPWUnits);
            wi.setCallback(cbLabel, : getPPWLabel);
          }
        default:
      }

      return wi;
    }

    function getInstance(showInfo) as WhatInfoBase {
      return _getInstance(showInfo, mHrFallback, mTrainingEffectFallback);
    }

    function _getInstance(showInfo, hrFallback,
                          trainingEffectFallback) as WhatInfoBase {
    //   if (mDebug) {
    //     System.println("_getInstance showInfo: " + showInfo);
    //   }
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
            mwHeartrate.updateInfo(mInfo);
            if (!mwHeartrate.isAvailable() && hrFallback != ShowInfoNothing) {
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
          if (mwTime == null) {
            mwTime = new WhatTime();
          }
          return mwTime;

        case ShowInfoCalories:
          if (mwCalories == null) {
            mwCalories = new WhatCalories();
          }
          return mwCalories;

          //@@TODO   case ShowInfoTotalAscent:

          //     return new WhatInformation(mwAltitude);
          //   case ShowInfoTotalDescent:
          //     return new WhatInformation(mwAltitude);
        case ShowInfoTrainingEffect:
          if (mwTrainingEffect == null) {
            mwTrainingEffect = new WhatTrainingEffect();
          }

          if (mInfo != null) {
            mwTrainingEffect.updateInfo(mInfo);
            if (!mwTrainingEffect.isAvailable() &&
                trainingEffectFallback != ShowInfoNothing) {
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
          //   var nope = null as WhatInfoBase;
          return null as WhatInfoBase;
      }
    }
  }
}

// @@ factory
// - load settings / get active instance
// - detect only updateInfo once! if same instance