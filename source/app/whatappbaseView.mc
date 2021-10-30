import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
using WhatAppBase.Types;

module WhatAppBase {
  class WhatAppView extends WatchUi.DataField {
    hidden var mWD;
    hidden var mNoInfo = null as Activity.Info;
    hidden var mWhatApp = null as WhatApp;

    function initialize(whatApp as WhatApp) {
      DataField.initialize();
      mWD = new WhatDisplay();
      mWhatApp = whatApp;
    }

    // Set your layout here. Anytime the size of obscurity of
    // the draw context is changed this will be called.
    function onLayout(dc as Dc) as Void { mWD.onLayout(dc); }

    // The given info object contains all the current workout information.
    // Calculate a value and save it locally in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no
    // guarantee that compute() will be called before onUpdate().
    function compute(info as Activity.Info) as Void {
      mWhatApp._wiTop = getShowInformation(
          mWhatApp._showInfoTop, mWhatApp._showInfoHrFallback,
          mWhatApp._showInfoTrainingEffectFallback, info);
      mWhatApp._wiBottom = getShowInformation(
          mWhatApp._showInfoBottom, mWhatApp._showInfoHrFallback,
          mWhatApp._showInfoTrainingEffectFallback, info);
      mWhatApp._wiLeft = getShowInformation(
          mWhatApp._showInfoLeft, mWhatApp._showInfoHrFallback,
          mWhatApp._showInfoTrainingEffectFallback, info);
      mWhatApp._wiRight = getShowInformation(
          mWhatApp._showInfoRight, mWhatApp._showInfoHrFallback,
          mWhatApp._showInfoTrainingEffectFallback, info);

      if (mWhatApp._wiTop != null) {
        mWhatApp._wiTop.updateInfo(info);
      }
      if (mWhatApp._wiBottom != null) {
        mWhatApp._wiBottom.updateInfo(info);
      }
      if (mWhatApp._wiLeft != null) {
        mWhatApp._wiLeft.updateInfo(info);
      }
      if (mWhatApp._wiRight != null) {
        mWhatApp._wiRight.updateInfo(info);
      }
    }

    // Display the value you computed here. This will be called
    // once a second when the data field is visible.
    function onUpdate(dc as Dc) as Void {
      mWD.onUpdate(dc);
      mWD.clearDisplay(getBackgroundColor(), getBackgroundColor());
      mWD.setNightMode((getBackgroundColor() == Graphics.COLOR_BLACK));
      var TopFontColor = null;
      if (mWD.isNightMode()) {  // @@ in mWD
        TopFontColor = Graphics.COLOR_WHITE;
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
      } else {
        TopFontColor = Graphics.COLOR_BLACK;
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
      }

      mWhatApp._wiTop = getShowInformation(
          mWhatApp._showInfoTop, mWhatApp._showInfoHrFallback,
          mWhatApp._showInfoTrainingEffectFallback, mNoInfo);
      mWhatApp._wiBottom = getShowInformation(
          mWhatApp._showInfoBottom, mWhatApp._showInfoHrFallback,
          mWhatApp._showInfoTrainingEffectFallback, mNoInfo);
      mWhatApp._wiLeft = getShowInformation(
          mWhatApp._showInfoLeft, mWhatApp._showInfoHrFallback,
          mWhatApp._showInfoTrainingEffectFallback, mNoInfo);
      mWhatApp._wiRight = getShowInformation(
          mWhatApp._showInfoRight, mWhatApp._showInfoHrFallback,
          mWhatApp._showInfoTrainingEffectFallback, mNoInfo);

      var showTop = mWhatApp._wiTop != null;
      var showLeft = mWhatApp._wiLeft != null;
      var showRight = mWhatApp._wiRight != null;
      var showBottom = mWhatApp._wiBottom != null;

      mWD.setShowTopInfo(showTop);
      mWD.setShowLeftInfo(showLeft);
      mWD.setShowRightInfo(showRight);
      mWD.setShowBottomInfo(showBottom);
      mWD.setMiddleLayout(mWhatApp._showInfoLayout);

      drawTopInfo(dc);
      drawLeftInfo(dc);
      drawRightInfo(dc);
      drawBottomInfo(dc);
    }

    function drawLeftInfo(dc) {
      if (mWhatApp._wiLeft == null) {
        return;
      }
      var value = mWhatApp._wiLeft.formattedValue(Types.SmallField);
      var zone = mWhatApp._wiLeft.zoneInfoValue();
      var avgZone = mWhatApp._wiLeft.zoneInfoAverage();
      var label = zone.name;
      if (mWhatApp._wiLeft.isLabelHidden()) {
        label = null;
      }
      mWD.drawLeftInfo(zone.fontColor, value, zone.color,
                       mWhatApp._wiLeft.units(), avgZone.color, zone.perc,
                       zone.color100perc, label);
    }
    function drawTopInfo(dc) {
      if (mWhatApp._wiTop == null) {
        return;
      }
      var value = mWhatApp._wiTop.formattedValue(Types.SmallField);
      var zone = mWhatApp._wiTop.zoneInfoValue();
      var avgZone = mWhatApp._wiTop.zoneInfoAverage();
      var label = zone.name;
      if (mWhatApp._wiTop.isLabelHidden()) {
        label = null;
      }
      mWD.drawTopInfo(zone.fontColor, value, zone.color,
                      mWhatApp._wiTop.units(), avgZone.color, zone.perc,
                      zone.color100perc, label);
    }

    function drawRightInfo(dc) {
      if (mWhatApp._wiRight == null) {
        return;
      }
      var value = mWhatApp._wiRight.formattedValue(Types.SmallField);
      var zone = mWhatApp._wiRight.zoneInfoValue();
      var avgZone = mWhatApp._wiRight.zoneInfoAverage();
      var label = zone.name;
      if (mWhatApp._wiRight.isLabelHidden()) {
        label = null;
      }
      mWD.drawRightInfo(zone.fontColor, value, zone.color,
                        mWhatApp._wiRight.units(), avgZone.color, zone.perc,
                        zone.color100perc, label);
    }

    function drawBottomInfo(dc) {
      if (mWhatApp._wiBottom == null) {
        return;
      }
      var value = mWhatApp._wiBottom.formattedValue(mWD.fieldType);
      var zone = mWhatApp._wiBottom.zoneInfoValue();
      var avgZone = mWhatApp._wiBottom.zoneInfoAverage();
      var label = zone.name;
      if (mWhatApp._wiBottom.isLabelHidden()) {
        label = null;
      }
      mWD.drawBottomInfo(zone.fontColor, value, zone.color,
                         mWhatApp._wiBottom.units(), avgZone.color, zone.perc,
                         zone.color100perc, label);
    }

    function getShowInformation(showInfo, showInfoHrFallback,
                                showInfoTrainingEffectFallback,
                                info as Activity.Info) as WhatInformation {
      // System.println("showInfo: " + showInfo);
      switch (showInfo) {
        case ShowInfoPower:
          return new WhatInformation(
              mWhatApp._wPower.powerPerX(), mWhatApp._wPower.getAveragePower(),
              mWhatApp._wPower.getMaxPower(), mWhatApp._wPower);
        case ShowInfoHeartrate:
          if (info != null) {
            mWhatApp._wHeartrate.updateInfo(info);
          }
          if (!mWhatApp._wHeartrate.isAvailable() &&
              showInfoHrFallback != ShowInfoNothing) {
            return getShowInformation(showInfoHrFallback, ShowInfoNothing,
                                      ShowInfoNothing, mNoInfo);
          }
          return new WhatInformation(mWhatApp._wHeartrate.getCurrentHeartrate(),
                                     mWhatApp._wHeartrate.getAverageHeartrate(),
                                     mWhatApp._wHeartrate.getMaxHeartrate(),
                                     mWhatApp._wHeartrate);
        case ShowInfoSpeed:
          return new WhatInformation(mWhatApp._wSpeed.getCurrentSpeed(),
                                     mWhatApp._wSpeed.getAverageSpeed(),
                                     mWhatApp._wSpeed.getMaxSpeed(),
                                     mWhatApp._wSpeed);
        case ShowInfoCadence:
          return new WhatInformation(mWhatApp._wCadence.getCurrentCadence(),
                                     mWhatApp._wCadence.getAverageCadence(),
                                     mWhatApp._wCadence.getMaxCadence(),
                                     mWhatApp._wCadence);
        case ShowInfoAltitude:
          return new WhatInformation(mWhatApp._wAltitude.getCurrentAltitude(),
                                     0, 0, mWhatApp._wAltitude);
        case ShowInfoGrade:
          return new WhatInformation(mWhatApp._wGrade.getGrade(), 0, 0,
                                     mWhatApp._wGrade);
        case ShowInfoHeading:
          return new WhatInformation(
              mWhatApp._wHeading.getCurrentHeadingInDegrees(), 0, 0,
              mWhatApp._wHeading);
        case ShowInfoDistance:
          return new WhatInformation(
              mWhatApp._wDistance.getElapsedDistanceMorKm(), 0, 0,
              mWhatApp._wDistance);
        case ShowInfoAmbientPressure:
          return new WhatInformation(mWhatApp._wPressure.getPressure(), 0, 0,
                                     mWhatApp._wPressure);
        case ShowInfoTimeOfDay:
          return new WhatInformation(mWhatApp._wTime.getTime(), 0, 0,
                                     mWhatApp._wTime);
        case ShowInfoCalories:
          return new WhatInformation(mWhatApp._wCalories.getCalories(), 0, 0,
                                     mWhatApp._wCalories);
        case ShowInfoTotalAscent:
          return new WhatInformation(mWhatApp._wAltitude.getTotalAscent(), 0, 0,
                                     mWhatApp._wAltitude);
        case ShowInfoTotalDescent:
          return new WhatInformation(mWhatApp._wAltitude.getTotalDescent(), 0,
                                     0, mWhatApp._wAltitude);
        case ShowInfoTrainingEffect:
          if (info != null) {
            mWhatApp._wTrainingEffect.updateInfo(info);
          }
          if (!mWhatApp._wTrainingEffect.isAvailable() &&
              showInfoTrainingEffectFallback != ShowInfoNothing) {
            return getShowInformation(showInfoTrainingEffectFallback,
                                      ShowInfoNothing, ShowInfoNothing,
                                      mNoInfo);
          }
          return new WhatInformation(
              mWhatApp._wTrainingEffect.getTrainingEffect(), 0, 0,
              mWhatApp._wTrainingEffect);
        case ShowInfoEnergyExpenditure:
          return new WhatInformation(
              mWhatApp._wEngergyExpenditure.getEnergyExpenditure(), 0, 0,
              mWhatApp._wEngergyExpenditure);
        case ShowInfoNothing:
        default:
          var nope = null as WhatInformation;
          return nope;
      }
    }
  }
}