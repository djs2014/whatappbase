import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
using WhatAppBase.Utils as Utils;

(:typecheck(disableBackgroundCheck))
module WhatAppBase {
  var gWhatApp as WhatApp?;

  class WhatApp {
    var appName as String = "";
    var mFactory as BaseFactory = new BaseFactory();
    var mDebug as Boolean = false;
    var mBGServiceHandler as BGServiceHandler?; 
    var mHit as WhatAppHit = new WhatAppHit();
    // const FIVE_MINUTES = new Time.Duration(5 * 60);

    // Sensor info class?
    var mTemperature as Float?;

    var _showInfoLayout as LayoutMiddle = LayoutMiddleCircle;

    function initialize() {}

    function setAppName(appName as String) as Void { self.appName = appName; }
    
    function onStart(state as Dictionary?) as Void {    
    }
    
    function onStop(state as Dictionary?) as Void {
      mFactory.setFields(ShowInfoNothing,ShowInfoNothing,ShowInfoNothing,ShowInfoNothing);
      mFactory.cleanUp();    
    }
    
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
        var showInfoPowerFallback = Utils.getApplicationProperty("showInfoPowerFallback", ShowInfoAmbientPressure) as ShowInfo;

        mFactory.setFields(showInfoTop, showInfoLeft, showInfoRight, showInfoBottom);
        mFactory.setHrFallback(showInfoHrFallback);
        mFactory.setPowerFallback(showInfoPowerFallback);
        mFactory.setTrainingEffectFallback(showInfoTrainingEffectFallback);

        setProperties(mFactory.getInstance(showInfoTop));
        setProperties(mFactory.getInstance(showInfoLeft));
        setProperties(mFactory.getInstance(showInfoRight));
        setProperties(mFactory.getInstance(showInfoBottom));
        setProperties(mFactory.getInstance(showInfoHrFallback));
        setProperties(mFactory.getInstance(showInfoTrainingEffectFallback));

        _showInfoLayout = Utils.getApplicationProperty("showInfoLayout", LayoutMiddleCircle) as LayoutMiddle;
        
        mHit.setMode(Utils.getApplicationProperty("hitMode", WhatAppHit.HitDisabled) as WhatAppHit.HitMode);
        mHit.setSound(Utils.getApplicationProperty("hitSound", WhatAppHit.LowNoise) as WhatAppHit.HitSound);

        mHit.setStartOnPerc(Utils.getApplicationProperty("hitStartOnPerc", 150) as Number);
        mHit.setStopOnPerc(Utils.getApplicationProperty("hitStopOnPerc", 100) as Number);
        mHit.setStartCountDownSeconds(Utils.getApplicationProperty("hitStartCountDownSeconds", 5) as Number);
        mHit.setStopCountDownSeconds(Utils.getApplicationProperty("hitStopCountDownSeconds", 10) as Number);
              
        var bgHandler = getBGServiceHandler() as BGServiceHandler;
        if (mFactory.needSensorData()) {
          bgHandler.Enable(); 
        } else {
          bgHandler.Disable(); 
        }
        mBGServiceHandler = bgHandler;

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
      } else if (obj instanceof WhatGrade) {
        obj.setTargetGrade(Utils.getApplicationProperty("targetGrade", 8) as Number);  
      } else if (obj instanceof WhatTemperature) {
        obj.setTargetTemperature(Utils.getApplicationProperty("targetTemperature", 20) as Number);  
      } else if (obj instanceof WhatAltitude) {
        obj.setTargetAltitude(Utils.getApplicationProperty("targetAltitude", 1500) as Number);  
        obj.setTargetTotalAscent(Utils.getApplicationProperty("targetTotalAscent", 2000) as Number);         
      }
    }
        
    function onBackgroundData(data as Application.PersistableType) as Void {
        System.println("Background data recieved");
        
        if (data instanceof Dictionary) {
          if (data.isEmpty()) { return; }
         
          if (data.hasKey("Temperature")) { 
            var wt = mFactory.getTemperatureInstance();
            if (wt != null) {
              wt.setTemperature(data["Temperature"]);
            }
            //@@ remove mTemperature = data["Temperature"];                              
          }

        }
    }

    function getBGServiceHandler() as BGServiceHandler {
      if (mBGServiceHandler == null) { mBGServiceHandler = new BGServiceHandler(); }
      return mBGServiceHandler;
    }

    static function instance() as WhatApp {
      if (gWhatApp == null) { gWhatApp = new WhatApp(); }
      return gWhatApp;
    }
    
  }
}