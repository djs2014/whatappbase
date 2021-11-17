import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
// using WhatAppBase.Types;

module WhatAppBase {
  class WhatAppView extends WatchUi.DataField {
    hidden var mApp as WhatApp?;
    hidden var mNoInfo as Activity.Info?;
    hidden var mWD as WhatDisplay = new WhatDisplay();
    hidden var mFactory as BaseFactory;
    hidden var mShowAppName as Boolean = false;

    hidden var mWiTop as WhatInformation?;
    hidden var mWiLeft as WhatInformation?;
    hidden var mWiRight as WhatInformation?;
    hidden var mWiBottom as WhatInformation?;

    function initialize(whatApp as WhatApp) {
      DataField.initialize();
      mApp = whatApp;
      mFactory = mApp.mFactory;
    }

    // Set your layout here. Anytime the size of obscurity of
    // the draw context is changed this will be called.
    // @@ Detect radar icon in right upper corner
    function onLayout(dc as Dc) as Void { mWD.onLayout(dc); }

    // The given info object contains all the current workout information.
    // Calculate a value and save it locally in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no
    // guarantee that compute() will be called before onUpdate().
    function compute(info as Activity.Info) as Void {
      mFactory.setInfo(info);

      mWiTop = mFactory.getWI_Top();
      mWiLeft = mFactory.getWI_Left();
      mWiRight = mFactory.getWI_Right();
      mWiBottom = mFactory.getWI_Bottom();

      // @@ TODO check same obj instance call updateInfo twice
      if (mWiTop != null) {
        mWiTop.updateInfo(info);
      }
      if (mWiLeft != null) {
        mWiLeft.updateInfo(info);
      }
      if (mWiRight != null) {
        mWiRight.updateInfo(info);
      }
      if (mWiBottom != null) {
        mWiBottom.updateInfo(info);
      }

      mShowAppName = true;
      if (info has : timerState) {
        mShowAppName = (info.timerState != Activity.TIMER_STATE_ON);
      }
    }

    // Display the value you computed here. This will be called
    // once a second when the data field is visible.
    function onUpdate(dc as Dc) as Void {    
      dc.setColor(getBackgroundColor(), getBackgroundColor());
      dc.clear();
      mWD.onUpdate(dc);

      mWD.setNightMode((getBackgroundColor() == Graphics.COLOR_BLACK));
      var TopFontColor = null;
      if (mWD.isNightMode()) {  // @@ in mWD
        TopFontColor = Graphics.COLOR_WHITE;
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
      } else {
        TopFontColor = Graphics.COLOR_BLACK;
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
      }

      mWiTop = mFactory.getWI_Top();
      mWiLeft = mFactory.getWI_Left();
      mWiRight = mFactory.getWI_Right();
      mWiBottom = mFactory.getWI_Bottom();

      mWD.setShowTopInfo(mWiTop != null);
      mWD.setShowLeftInfo(mWiLeft != null);
      mWD.setShowRightInfo(mWiRight != null);
      mWD.setShowBottomInfo(mWiBottom != null);

      var app = mApp as WhatApp;
      mWD.setMiddleLayout(app._showInfoLayout);

      drawBottomInfoBG(dc);
      drawTopInfo(dc);
      drawLeftInfo(dc);
      drawRightInfo(dc);
      drawBottomInfoFG(dc);
      // @@ callback option?
      if (mShowAppName && app.appName != null && app.appName.length() > 0) {
        dc.setColor(Graphics.COLOR_ORANGE, Graphics.COLOR_BLACK);
        dc.drawText(0, 0, Graphics.FONT_XTINY, app.appName,
                    Graphics.TEXT_JUSTIFY_LEFT);
      }
    }
     
    function drawLeftInfo(dc as Dc) as Void {
      if (mWiLeft == null) {
        return;
      }
      var wi = mWiLeft as WhatInformation;

      var value = wi.getFormattedValue();
      var zone = wi.getZoneInfo();
      var units = wi.getUnits();

      var label = zone.name;
      if (wi.isLabelHidden()) {  // @@
        label = "";
      }
      var altZone = wi.getAltZoneInfo();
      var maxZone = wi.getMaxZoneInfo();
      mWD.drawLeftInfo(label, value, units, zone, altZone, maxZone);
    }
    function drawTopInfo(dc as Dc) as Void {
      if (mWiTop == null) {
        return;
      }
      var wi = mWiTop as WhatInformation;

      var value = wi.getFormattedValue();
      var zone = wi.getZoneInfo();
      var units = wi.getUnits();

      var label = zone.name;
      if (wi.isLabelHidden()) {  // @@
        label = "";
      }
      var altZone = wi.getAltZoneInfo();
      var maxZone = wi.getMaxZoneInfo();
      mWD.drawTopInfo(label, value, units, zone, altZone, maxZone);
    }

    function drawRightInfo(dc as Dc) as Void {
      if (mWiRight == null) {
        return;
      }
      var wi = mWiRight as WhatInformation;

      var value = wi.getFormattedValue();
      var zone = wi.getZoneInfo();
      var units = wi.getUnits();

      var label = zone.name;
      if (wi.isLabelHidden()) {  // @@
        label = "";
      }
      var altZone = wi.getAltZoneInfo();
      var maxZone = wi.getMaxZoneInfo();
      mWD.drawRightInfo(label, value, units, zone, altZone, maxZone);
    }

    function drawBottomInfoBG(dc as Dc) as Void {
      if (mWiBottom == null) {
        return;
      }
      var wi = mWiBottom as WhatInformation;

      var value = wi.getFormattedValue();
      var zone = wi.getZoneInfo();
      var units = wi.getUnits();

      var label = zone.name;
      if (wi.isLabelHidden()) {  // @@
        label = "";
      }
      var altZone = wi.getAltZoneInfo();
      var maxZone = wi.getMaxZoneInfo();
      mWD.drawBottomInfoBG(label, value, units, zone, altZone, maxZone);
    }
    function drawBottomInfoFG(dc as Dc) as Void {
      if (mWiBottom == null) {
        return;
      }
      var wi = mWiBottom as WhatInformation;

      var value = wi.getFormattedValue();
      var zone = wi.getZoneInfo();
      var units = wi.getUnits();

      var label = zone.name;
      if (wi.isLabelHidden()) {  // @@
        label = "";
      }
      var altZone = wi.getAltZoneInfo();
      var maxZone = wi.getMaxZoneInfo();
      mWD.drawBottomInfoFG(label, value, units, zone, altZone, maxZone);
    }
  }
}