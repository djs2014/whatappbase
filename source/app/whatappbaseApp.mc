import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
using WhatAppBase.Utils as Utils;

module WhatAppBase {
  class WhatApp {
    var appName as String = "";
    var mFactory as BaseFactory = new BaseFactory();
    var mDebug as Boolean = false;

    var mHit as WhatAppHit = new WhatAppHit();
    // const FIVE_MINUTES = new Time.Duration(5 * 60);

    var _showInfoLayout as LayoutMiddle = LayoutMiddleCircle;

    function initialize() {}

    function setAppName(appName as String) as Void { self.appName = appName; }
    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {    
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
      mFactory.setFields(ShowInfoNothing,ShowInfoNothing,ShowInfoNothing,ShowInfoNothing);
      mFactory.cleanUp();        
    }

    //! Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates> ? {
      loadUserSettings();
      return [new WhatAppView(self)] as Array < Views or InputDelegates > ;
    }

    function onSettingsChanged() as Void { loadUserSettings(); }

    function loadUserSettings() as Void {
      try {
        var showInfoTop = Utils.getApplicationProperty("showInfoTop", ShowInfoTrainingEffect) as ShowInfo;
        var showInfoLeft = Utils.getApplicationProperty("showInfoLeft", ShowInfoPower) as ShowInfo;
        var showInfoRight = Utils.getApplicationProperty("showInfoRight", ShowInfoHeartrate) as ShowInfo;
        var showInfoBottom = Utils.getApplicationProperty("showInfoBottom", ShowInfoCalories) as ShowInfo;
        var showInfoHrFallback = Utils.getApplicationProperty("showInfoHrFallback", ShowInfoCadence) as ShowInfo;
        var showInfoTrainingEffectFallback = Utils.getApplicationProperty("showInfoTrainingEffectFallback", ShowInfoEnergyExpenditure) as ShowInfo;

        mFactory.setFields(showInfoTop, showInfoLeft, showInfoRight, showInfoBottom);
        mFactory.setHrFallback(showInfoHrFallback);
        mFactory.setTrainingEffectFallback(showInfoTrainingEffectFallback);

        setProperties(mFactory.getInstance(showInfoTop));
        setProperties(mFactory.getInstance(showInfoLeft));
        setProperties(mFactory.getInstance(showInfoRight));
        setProperties(mFactory.getInstance(showInfoBottom));
        setProperties(mFactory.getInstance(showInfoHrFallback));
        setProperties(mFactory.getInstance(showInfoTrainingEffectFallback));

        _showInfoLayout = Utils.getApplicationProperty("showInfoLayout", LayoutMiddleCircle) as LayoutMiddle;

        // Settings
        mHit.setMode(Utils.getApplicationProperty("hitMode", WhatAppHit.HitDisabled) as WhatAppHit.HitMode);
        mHit.setSound(Utils.getApplicationProperty("hitSound", WhatAppHit.LowNoise) as WhatAppHit.HitSound);

        mHit.setStartOnPerc(Utils.getApplicationProperty("hitStartOnPerc", 150) as Number);
        mHit.setStopOnPerc(Utils.getApplicationProperty("hitStopOnPerc", 100) as Number);
        mHit.setStartCountDownSeconds(Utils.getApplicationProperty("hitStartCountDownSeconds", 5) as Number);
        mHit.setStopCountDownSeconds(Utils.getApplicationProperty("hitStopCountDownSeconds", 10) as Number);
              
        mFactory.cleanUp();      
        System.println("Settings loaded");
        if (mFactory.isDebug()) {
          mFactory.infoSettings();
        }
      } catch (ex) {
        ex.printStackTrace();
      }
    }

    function setProperties(obj as WhatInfoBase) as Void {
      mDebug = Utils.getApplicationProperty("debug", false) as Boolean;
      mFactory.setDebug(mDebug);
      if (obj == null) {
        return;
      }
      obj.setDebug(mDebug);

      if (obj instanceof WhatPower) {
        obj.setFtp(Utils.getApplicationProperty("ftpValue", 200) as Number);
        obj.setPerSec(Utils.getApplicationProperty("powerPerSecond", 3) as Number);        
        obj.initWeight();
      } else if (obj instanceof WhatVo2Max) {
        obj.setFtp(Utils.getApplicationProperty("ftpValue", 200) as Number);
        obj.initWeight();
      } else if (obj instanceof WhatPressure) {
        obj.setShowSeaLevelPressure(Utils.getApplicationProperty("showSeaLevelPressure", true) as Boolean);
        obj.setPerMin(Utils.getApplicationProperty("calcAvgPressurePerMinute", 30) as Number);
        obj.reset();
      } else if (obj instanceof WhatHeartrate) {
        obj.initZones();
      } else if (obj instanceof WhatSpeed) {
        obj.setTargetSpeed(Utils.getApplicationProperty("targetSpeed", 30.0) as Float);
      } else if (obj instanceof WhatCadence) {
        obj.setTargetCadence(Utils.getApplicationProperty("targetCadence", 95) as Number);
      } else if (obj instanceof WhatDistance) {
        obj.setTargetDistance(Utils.getApplicationProperty("targetDistance", 150.0) as Float);
      } else if (obj instanceof WhatCalories) {
        obj.setTargetCalories(Utils.getApplicationProperty("targetCalories", 2000) as Number);
        obj.setTargetEngergyExpenditure(Utils.getApplicationProperty("targetEnergyExpenditure", 15.0) as Float);
      } else if (obj instanceof WhatEnergyExpenditure) {
        obj.setTargetEngergyExpenditure(Utils.getApplicationProperty("targetEnergyExpenditure", 15.0) as Float);
      } else if (obj instanceof WhatHeading) {
        obj.setMinimalLocationAccuracy(Utils.getApplicationProperty("minimalLocationAccuracy", 0) as Number);
        obj.setMinimalElapsedDistanceInMeters(Utils.getApplicationProperty("minimalElapsedDistanceInMeters", 0) as Number);
      } else if (obj instanceof WhatTestField) {
        obj.setTargetValue(Utils.getApplicationProperty("targetTestValue", 100) as Number);
        obj.setValue(Utils.getApplicationProperty("testValue", 145));
        obj.setAltValue(Utils.getApplicationProperty("testAltValue", 80) as Number);
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