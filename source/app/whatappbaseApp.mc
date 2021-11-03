import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
using WhatAppBase.Utils;

module WhatAppBase {
  class WhatApp {
    var appName = "";
    var mFactory = new BaseFactory();
    var mDebug = false;

    var _showInfoLayout = LayoutMiddleCircle;

    function initialize(appName as Lang.String) { self.appName = appName; }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    //! Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates> ? {
      loadUserSettings();
      return [new WhatAppView(self)] as Array < Views or InputDelegates > ;
    }

    function onSettingsChanged() { loadUserSettings(); }

    function loadUserSettings() {
      try {
        var showInfoTop =
            Utils.getNumberProperty("showInfoTop", ShowInfoTrainingEffect);
        var showInfoLeft =
            Utils.getNumberProperty("showInfoLeft", ShowInfoPower);
        var showInfoRight =
            Utils.getNumberProperty("showInfoRight", ShowInfoHeartrate);
        var showInfoBottom =
            Utils.getNumberProperty("showInfoBottom", ShowInfoCalories);
        var showInfoHrFallback =
            Utils.getNumberProperty("showInfoHrFallback", ShowInfoCadence);
        var showInfoTrainingEffectFallback = Utils.getNumberProperty(
            "showInfoTrainingEffectFallback", ShowInfoEnergyExpenditure);

        mFactory.setFields(showInfoTop, showInfoLeft, showInfoRight,
                           showInfoBottom);
        mFactory.setHrFallback(showInfoHrFallback);
        mFactory.setTrainingEffectFallback(showInfoTrainingEffectFallback);

        setProperties(mFactory.getInstance(showInfoTop));
        setProperties(mFactory.getInstance(showInfoLeft));
        setProperties(mFactory.getInstance(showInfoRight));
        setProperties(mFactory.getInstance(showInfoBottom));
        setProperties(mFactory.getInstance(showInfoHrFallback));
        setProperties(mFactory.getInstance(showInfoTrainingEffectFallback));

        _showInfoLayout =
            Utils.getNumberProperty("showInfoLayout", LayoutMiddleCircle);

        System.println("Settings loaded");
        if (mFactory.isDebug()) {
          mFactory.infoSettings();
        }
      } catch (ex) {
        ex.printStackTrace();
      }
    }

    function setProperties(obj as WhatInfoBase) as Void {
      mDebug = Utils.getBooleanProperty("debug", false);
      mFactory.setDebug(mDebug);
      if (obj == null) {
        return;
      }
      obj.setDebug(mDebug);

      if (obj instanceof WhatPower) {
        obj.setFtp(Utils.getNumberProperty("ftpValue", 200));
        obj.setPerSec(Utils.getNumberProperty("powerPerSecond", 3));
        obj.initWeight();
      } else if (obj instanceof WhatPressure) {
        obj.setShowSeaLevelPressure(
            Utils.getBooleanProperty("showSeaLevelPressure", true));
        obj.setPerMin(Utils.getNumberProperty("calcAvgPressurePerMinute", 30));
        obj.reset();
      } else if (obj instanceof WhatHeartrate) {
        obj.initZones();
      } else if (obj instanceof WhatSpeed) {
        obj.setTargetSpeed(Utils.getNumberProperty("targetSpeed", 30));
      } else if (obj instanceof WhatCadence) {
        obj.setTargetCadence(Utils.getNumberProperty("targetCadence", 95));
      } else if (obj instanceof WhatDistance) {
        obj.setTargetDistance(Utils.getNumberProperty("targetDistance", 150));
      } else if (obj instanceof WhatCalories) {
        obj.setTargetCalories(Utils.getNumberProperty("targetCalories", 2000));
      } else if (obj instanceof WhatEnergyExpenditure) {
        obj.setTargetEngergyExpenditure(
            Utils.getNumberProperty("targetEnergyExpenditure", 15));
      } else if (obj instanceof WhatHeading) {
        obj.setMinimalLocationAccuracy(
            Utils.getNumberProperty("minimalLocationAccuracy", 0));
        obj.setMinimalElapsedDistanceInMeters(
            Utils.getNumberProperty("minimalElapsedDistanceInMeters", 0));
      } else if (obj instanceof WhatTestField) {
        obj.setTargetValue(Utils.getNumberProperty("targetTestValue", 100));
        obj.setValue(Utils.getNumberProperty("testValue", 250));
      }
    }
  }

  //   function
  //   getApp() as whatpowerApp {
  //     return Application.getApp() as whatpowerApp;
  //   }
}