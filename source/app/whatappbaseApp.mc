import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
using WhatAppBase.Utils as Utils;

module WhatAppBase {
  class WhatApp {
    var appName as String = "";
    var mFactory as BaseFactory = new BaseFactory();
    var mDebug as Boolean = false;
    // const FIVE_MINUTES = new Time.Duration(5 * 60);

    var _showInfoLayout as LayoutMiddle = LayoutMiddleCircle;

    function initialize() {}

    function setAppName(appName as String) as Void { self.appName = appName; }
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

    function onSettingsChanged() as Void { loadUserSettings(); }

    function loadUserSettings() as Void {
      try {
        var showInfoTop = Utils.getNumberProperty("showInfoTop", ShowInfoTrainingEffect) as ShowInfo;
        var showInfoLeft = Utils.getNumberProperty("showInfoLeft", ShowInfoPower) as ShowInfo;
        var showInfoRight = Utils.getNumberProperty("showInfoRight", ShowInfoHeartrate) as ShowInfo;
        var showInfoBottom = Utils.getNumberProperty("showInfoBottom", ShowInfoCalories) as ShowInfo;
        var showInfoHrFallback = Utils.getNumberProperty("showInfoHrFallback", ShowInfoCadence) as ShowInfo;
        var showInfoTrainingEffectFallback = Utils.getNumberProperty("showInfoTrainingEffectFallback", ShowInfoEnergyExpenditure) as ShowInfo;

        mFactory.setFields(showInfoTop, showInfoLeft, showInfoRight, showInfoBottom);
        mFactory.setHrFallback(showInfoHrFallback);
        mFactory.setTrainingEffectFallback(showInfoTrainingEffectFallback);

        setProperties(mFactory.getInstance(showInfoTop));
        setProperties(mFactory.getInstance(showInfoLeft));
        setProperties(mFactory.getInstance(showInfoRight));
        setProperties(mFactory.getInstance(showInfoBottom));
        setProperties(mFactory.getInstance(showInfoHrFallback));
        setProperties(mFactory.getInstance(showInfoTrainingEffectFallback));

        _showInfoLayout = Utils.getNumberProperty("showInfoLayout", LayoutMiddleCircle) as LayoutMiddle;

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
        obj.setTargetSpeed(Utils.getFloatProperty("targetSpeed", 30.0));
      } else if (obj instanceof WhatCadence) {
        obj.setTargetCadence(Utils.getNumberProperty("targetCadence", 95));
      } else if (obj instanceof WhatDistance) {
        obj.setTargetDistance(Utils.getFloatProperty("targetDistance", 150.0));
      } else if (obj instanceof WhatCalories) {
        obj.setTargetCalories(Utils.getNumberProperty("targetCalories", 2000));
      } else if (obj instanceof WhatEnergyExpenditure) {
        obj.setTargetEngergyExpenditure( Utils.getFloatProperty("targetEnergyExpenditure", 15.0));
      } else if (obj instanceof WhatHeading) {
        obj.setMinimalLocationAccuracy(Utils.getNumberProperty("minimalLocationAccuracy", 0));
        obj.setMinimalElapsedDistanceInMeters(Utils.getNumberProperty("minimalElapsedDistanceInMeters", 0));
      } else if (obj instanceof WhatTestField) {
        obj.setTargetValue(Utils.getNumberProperty("targetTestValue", 100));
        obj.setValue(Utils.getNumberProperty("testValue", 145));
        obj.setAltValue(Utils.getNumberProperty("testAltValue", 80));
      // } else if (obj instanceof WhatTemperature) {
      //   if (System has : ServiceDelegate) {
      //     Background.registerForTemporalEvent(FIVE_MINUTES);
      //   } else {
      //     System.println("**** background not available on this device ****");
      //   }
      }
    }
  }
}