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
    hidden var mApp = null as WhatApp;
    hidden var mShowAppName = false as Lang.Boolean;

    function initialize(whatApp as WhatApp) {
      DataField.initialize();
      mWD = new WhatDisplay();
      mApp = whatApp;
    }

    // Set your layout here. Anytime the size of obscurity of
    // the draw context is changed this will be called.
    function onLayout(dc as Dc) as Void { mWD.onLayout(dc); }

    // The given info object contains all the current workout information.
    // Calculate a value and save it locally in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no
    // guarantee that compute() will be called before onUpdate().
    function compute(info as Activity.Info) as Void {
      mApp._wiTop =
          getShowInformation(mApp._showInfoTop, mApp._showInfoHrFallback,
                             mApp._showInfoTrainingEffectFallback, info);
      mApp._wiBottom =
          getShowInformation(mApp._showInfoBottom, mApp._showInfoHrFallback,
                             mApp._showInfoTrainingEffectFallback, info);
      mApp._wiLeft =
          getShowInformation(mApp._showInfoLeft, mApp._showInfoHrFallback,
                             mApp._showInfoTrainingEffectFallback, info);
      mApp._wiRight =
          getShowInformation(mApp._showInfoRight, mApp._showInfoHrFallback,
                             mApp._showInfoTrainingEffectFallback, info);

      if (mApp._wiTop != null) {
        mApp._wiTop.updateInfo(info);
      }
      if (mApp._wiBottom != null) {
        mApp._wiBottom.updateInfo(info);
      }
      if (mApp._wiLeft != null) {
        mApp._wiLeft.updateInfo(info);
      }
      if (mApp._wiRight != null) {
        mApp._wiRight.updateInfo(info);
      }

      mShowAppName = true;
      if (info has : timerState) {
        mShowAppName = (info.timerState != Activity.TIMER_STATE_ON);
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

      mApp._wiTop =
          getShowInformation(mApp._showInfoTop, mApp._showInfoHrFallback,
                             mApp._showInfoTrainingEffectFallback, mNoInfo);
      mApp._wiBottom =
          getShowInformation(mApp._showInfoBottom, mApp._showInfoHrFallback,
                             mApp._showInfoTrainingEffectFallback, mNoInfo);
      mApp._wiLeft =
          getShowInformation(mApp._showInfoLeft, mApp._showInfoHrFallback,
                             mApp._showInfoTrainingEffectFallback, mNoInfo);
      mApp._wiRight =
          getShowInformation(mApp._showInfoRight, mApp._showInfoHrFallback,
                             mApp._showInfoTrainingEffectFallback, mNoInfo);

      var showTop = mApp._wiTop != null;
      var showLeft = mApp._wiLeft != null;
      var showRight = mApp._wiRight != null;
      var showBottom = mApp._wiBottom != null;

      mWD.setShowTopInfo(showTop);
      mWD.setShowLeftInfo(showLeft);
      mWD.setShowRightInfo(showRight);
      mWD.setShowBottomInfo(showBottom);
      mWD.setMiddleLayout(mApp._showInfoLayout);


      drawTopInfo(dc);
      drawLeftInfo(dc);
      drawRightInfo(dc);
      drawBottomInfo(dc);

      if (mShowAppName && mApp.appName != null && mApp.appName.length()>0) {
        dc.setColor(Graphics.COLOR_ORANGE, Graphics.COLOR_BLACK);
        dc.drawText(0, 0, Graphics.FONT_XTINY, mApp.appName, Graphics.TEXT_JUSTIFY_LEFT);
      }
    }

    function drawLeftInfo(dc) {
      if (mApp._wiLeft == null) {
        return;
      }
      var value = mApp._wiLeft.formattedValue(Types.SmallField);
      var zone = mApp._wiLeft.zoneInfoValue();
      var avgZone = mApp._wiLeft.zoneInfoAverage();
      var label = zone.name;
      if (mApp._wiLeft.isLabelHidden()) {
        label = "";
      }
      mWD.drawLeftInfo(zone.fontColor, value, zone.color, mApp._wiLeft.units(),
                       avgZone.color, zone.perc, zone.color100perc, label);
    }
    function drawTopInfo(dc) {
      if (mApp._wiTop == null) {
        return;
      }
      var value = mApp._wiTop.formattedValue(Types.SmallField);
      var zone = mApp._wiTop.zoneInfoValue();
      var avgZone = mApp._wiTop.zoneInfoAverage();
      var label = zone.name;
      if (mApp._wiTop.isLabelHidden()) {
        label = "";
      }
      mWD.drawTopInfo(zone.fontColor, value, zone.color, mApp._wiTop.units(),
                      avgZone.color, zone.perc, zone.color100perc, label);
    }

    function drawRightInfo(dc) {
      if (mApp._wiRight == null) {
        return;
      }
      var value = mApp._wiRight.formattedValue(Types.SmallField);
      var zone = mApp._wiRight.zoneInfoValue();
      var avgZone = mApp._wiRight.zoneInfoAverage();
      var label = zone.name;
      if (mApp._wiRight.isLabelHidden()) {
        label = "";
      }
      mWD.drawRightInfo(zone.fontColor, value, zone.color,
                        mApp._wiRight.units(), avgZone.color, zone.perc,
                        zone.color100perc, label);
    }

    function drawBottomInfo(dc) {
      if (mApp._wiBottom == null) {
        return;
      }
      var value = mApp._wiBottom.formattedValue(mWD.fieldType);
      var zone = mApp._wiBottom.zoneInfoValue();
      var avgZone = mApp._wiBottom.zoneInfoAverage();
      var label = zone.name;
      if (mApp._wiBottom.isLabelHidden()) {
        label = "";
      }
      mWD.drawBottomInfo(zone.fontColor, value, zone.color,
                         mApp._wiBottom.units(), avgZone.color, zone.perc,
                         zone.color100perc, label);
    }

    function getShowInformation(showInfo, showInfoHrFallback,
                                showInfoTrainingEffectFallback,
                                info as Activity.Info) as WhatInformation {
      // System.println("showInfo: " + showInfo);
      switch (showInfo) {
        case ShowInfoPower:
          return new WhatInformation(mApp._wPower.powerPerX(),
                                     mApp._wPower.getAveragePower(),
                                     mApp._wPower.getMaxPower(), mApp._wPower);
        case ShowInfoHeartrate:
          if (info != null) {
            mApp._wHeartrate.updateInfo(info);
          }
          if (!mApp._wHeartrate.isAvailable() &&
              showInfoHrFallback != ShowInfoNothing) {
            return getShowInformation(showInfoHrFallback, ShowInfoNothing,
                                      ShowInfoNothing, mNoInfo);
          }
          return new WhatInformation(mApp._wHeartrate.getCurrentHeartrate(),
                                     mApp._wHeartrate.getAverageHeartrate(),
                                     mApp._wHeartrate.getMaxHeartrate(),
                                     mApp._wHeartrate);
        case ShowInfoSpeed:
          return new WhatInformation(mApp._wSpeed.getCurrentSpeed(),
                                     mApp._wSpeed.getAverageSpeed(),
                                     mApp._wSpeed.getMaxSpeed(), mApp._wSpeed);
        case ShowInfoCadence:
          return new WhatInformation(mApp._wCadence.getCurrentCadence(),
                                     mApp._wCadence.getAverageCadence(),
                                     mApp._wCadence.getMaxCadence(),
                                     mApp._wCadence);
        case ShowInfoAltitude:
          return new WhatInformation(mApp._wAltitude.getCurrentAltitude(), 0, 0,
                                     mApp._wAltitude);
        case ShowInfoGrade:
          return new WhatInformation(mApp._wGrade.getGrade(), 0, 0,
                                     mApp._wGrade);
        case ShowInfoHeading:
          return new WhatInformation(
              mApp._wHeading.getCurrentHeadingInDegrees(), 0, 0,
              mApp._wHeading);
        case ShowInfoDistance:
          return new WhatInformation(mApp._wDistance.getElapsedDistanceMorKm(),
                                     0, 0, mApp._wDistance);
        case ShowInfoAmbientPressure:
          return new WhatInformation(mApp._wPressure.getPressure(), 0, 0,
                                     mApp._wPressure);
        case ShowInfoTimeOfDay:
          return new WhatInformation(mApp._wTime.getTime(), 0, 0, mApp._wTime);
        case ShowInfoCalories:
          return new WhatInformation(mApp._wCalories.getCalories(), 0, 0,
                                     mApp._wCalories);
        case ShowInfoTotalAscent:
          return new WhatInformation(mApp._wAltitude.getTotalAscent(), 0, 0,
                                     mApp._wAltitude);
        case ShowInfoTotalDescent:
          return new WhatInformation(mApp._wAltitude.getTotalDescent(), 0, 0,
                                     mApp._wAltitude);
        case ShowInfoTrainingEffect:
          if (info != null) {
            mApp._wTrainingEffect.updateInfo(info);
          }
          if (!mApp._wTrainingEffect.isAvailable() &&
              showInfoTrainingEffectFallback != ShowInfoNothing) {
            return getShowInformation(showInfoTrainingEffectFallback,
                                      ShowInfoNothing, ShowInfoNothing,
                                      mNoInfo);
          }
          return new WhatInformation(mApp._wTrainingEffect.getTrainingEffect(),
                                     0, 0, mApp._wTrainingEffect);
        case ShowInfoEnergyExpenditure:
          return new WhatInformation(
              mApp._wEngergyExpenditure.getEnergyExpenditure(), 0, 0,
              mApp._wEngergyExpenditure);
        case ShowInfoNothing:
        default:
          var nope = null as WhatInformation;
          return nope;
      }
    }
  }
}