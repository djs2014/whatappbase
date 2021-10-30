import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
using WhatAppBase.Utils;

module WhatAppBase {
  class WhatApp {
    var _wiTop = null as WhatInformation;
    var _wiLeft = null as WhatInformation;
    var _wiRight = null as WhatInformation;
    var _wiBottom = null as WhatInformation;

    var _wPower = null as WhatPower;
    var _wHeartrate = null as WhateHeartrate;
    var _wCadence = null as WhatCadence;
    var _wGrade = null as WhatGrade;
    var _wDistance = null as WhatDistance;
    var _wAltitude = null as WhatAltitude;
    var _wSpeed = null as WhatSpeed;
    var _wPressure = null as WhatPressure;
    var _wCalories = null as WhatCalories;
    var _wTrainingEffect = null as WhatTrainingEffect;
    var _wTime = null as WhatTime;
    var _wHeading = null as WhatHeading;
    var _wEngergyExpenditure = null as WhatEngergyExpenditure;

    var _showInfoTop = ShowInfoPower;
    var _showInfoLeft = ShowInfoNothing;
    var _showInfoRight = ShowInfoNothing;
    var _showInfoBottom = ShowInfoNothing;
    var _showInfoHrFallback = ShowInfoNothing;
    var _showInfoTrainingEffectFallback = ShowInfoNothing;
    var _showInfoLayout = LayoutMiddleCircle;
    var _showSealevelPressure = true;

    function initialize() {
      // AppBase.initialize();

      _wPower = new WhatPower();
      _wHeartrate = new WhateHeartrate();
      _wCadence = new WhatCadence();
      _wDistance = new WhatDistance();
      _wAltitude = new WhatAltitude();
      _wGrade = new WhatGrade();
      _wSpeed = new WhatSpeed();
      _wPressure = new WhatPressure();
      _wCalories = new WhatCalories();
      _wTrainingEffect = new WhatTrainingEffect();
      _wTime = new WhatTime();
      _wHeading = new WhatHeading();
      _wEngergyExpenditure = new WhatEngergyExpenditure();
    }

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
        _showInfoTop =
            Utils.getNumberProperty("showInfoTop", ShowInfoTrainingEffect);
        _showInfoLeft = Utils.getNumberProperty("showInfoLeft", ShowInfoPower);
        _showInfoRight =
            Utils.getNumberProperty("showInfoRight", ShowInfoHeartrate);
        _showInfoBottom =
            Utils.getNumberProperty("showInfoBottom", ShowInfoCalories);
        _showInfoHrFallback =
            Utils.getNumberProperty("showInfoHrFallback", ShowInfoCadence);
        _showInfoTrainingEffectFallback = Utils.getNumberProperty(
            "showInfoTrainingEffectFallback", ShowInfoEnergyExpenditure);

        _showInfoLayout =
            Utils.getNumberProperty("showInfoLayout", LayoutMiddleCircle);

        _wPower.setFtp(Utils.getNumberProperty("ftpValue", 200));
        _wPower.setPerSec(Utils.getNumberProperty("powerPerSecond", 3));

        _wPressure.setShowSeaLevelPressure(
            Utils.getBooleanProperty("showSeaLevelPressure", true));
        _wPressure.setPerMin(
            Utils.getNumberProperty("calcAvgPressurePerMinute", 30));
        _wPressure.reset();  //@@ QnD start activity

        _wHeartrate.initZones();
        _wSpeed.setTargetSpeed(Utils.getNumberProperty("targetSpeed", 30));
        _wCadence.setTargetCadence(
            Utils.getNumberProperty("targetCadence", 95));
        _wDistance.setTargetDistance(
            Utils.getNumberProperty("targetDistance", 150));
        _wCalories.setTargetCalories(
            Utils.getNumberProperty("targetCalories", 2000));
        _wEngergyExpenditure.setTargetEngergyExpenditure(
            Utils.getNumberProperty("targetEnergyExpenditure", 15));
        _wHeading.setMinimalLocationAccuracy(
            Utils.getNumberProperty("minimalLocationAccuracy", 2));

        System.println("Settings loaded");
      } catch (ex) {
        ex.printStackTrace();
      }
    }
  }

  //   function
  //   getApp() as whatpowerApp {
  //     return Application.getApp() as whatpowerApp;
  //   }
}