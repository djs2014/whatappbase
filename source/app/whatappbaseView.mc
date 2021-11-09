import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
using WhatAppBase.Types;

module WhatAppBase {
  class WhatAppView extends WatchUi.DataField {
    hidden var mApp = null as WhatApp;
    hidden var mNoInfo = null as Activity.Info;
    hidden var mWD;
    hidden var mFactory = null as BaseFactory;
    hidden var mShowAppName = false as Lang.Boolean;

    hidden var mWiTop = null;
    hidden var mWiLeft = null;
    hidden var mWiRight = null;
    hidden var mWiBottom = null;

    function initialize(whatApp as WhatApp) {
      DataField.initialize();
      mWD = new WhatDisplay();
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

      mWiTop = mFactory.getWI_Top();
      mWiLeft = mFactory.getWI_Left();
      mWiRight = mFactory.getWI_Right();
      mWiBottom = mFactory.getWI_Bottom();

      mWD.setShowTopInfo(mWiTop != null);
      mWD.setShowLeftInfo(mWiLeft != null);
      mWD.setShowRightInfo(mWiRight != null);
      mWD.setShowBottomInfo(mWiBottom != null);

      mWD.setMiddleLayout(mApp._showInfoLayout);

      drawBottomInfoBG(dc);
      drawTopInfo(dc);
      drawLeftInfo(dc);
      drawRightInfo(dc);
      drawBottomInfoFG(dc);

      // @@ callback option?
      if (mShowAppName && mApp.appName != null && mApp.appName.length() > 0) {
        dc.setColor(Graphics.COLOR_ORANGE, Graphics.COLOR_BLACK);
        dc.drawText(0, 0, Graphics.FONT_XTINY, mApp.appName,
                    Graphics.TEXT_JUSTIFY_LEFT);
      }
    }

    function drawLeftInfo(dc) {
      if (mWiLeft == null) {
        return;
      }
      var value = mWiLeft.getFormattedValue();
      var zone = mWiLeft.getZoneInfo();
      var units = mWiLeft.getUnits();

      var label = zone.name;
      if (mWiLeft.isLabelHidden()) {  // @@
        label = "";
      }
      var altZone = mWiLeft.getAltZoneInfo();
      var maxZone = mWiLeft.getMaxZoneInfo();
      mWD.drawLeftInfo(label, value, units, zone, altZone, maxZone);
    }
    function drawTopInfo(dc) {
      if (mWiTop == null) {
        return;
      }
      var value = mWiTop.getFormattedValue();
      var zone = mWiTop.getZoneInfo();
      var units = mWiTop.getUnits();

      var label = zone.name;
      if (mWiTop.isLabelHidden()) {  // @@
        label = "";
      }
      var altZone = mWiTop.getAltZoneInfo();
      var maxZone = mWiTop.getMaxZoneInfo();
      mWD.drawTopInfo(label, value, units, zone, altZone, maxZone);
    }

    function drawRightInfo(dc) {
      if (mWiRight == null) {
        return;
      }
      var value = mWiRight.getFormattedValue();
      var zone = mWiRight.getZoneInfo();
      var units = mWiRight.getUnits();

      var label = zone.name;
      if (mWiRight.isLabelHidden()) {  // @@
        label = "";
      }
      var altZone = mWiRight.getAltZoneInfo();
      var maxZone = mWiRight.getMaxZoneInfo();
      mWD.drawRightInfo(label, value, units, zone, altZone, maxZone);
    }

    function drawBottomInfoBG(dc) {
      if (mWiBottom == null) {
        return;
      }
      var value = mWiBottom.getFormattedValue();
      var zone = mWiBottom.getZoneInfo();
      var units = mWiBottom.getUnits();

      var label = zone.name;
      if (mWiBottom.isLabelHidden()) {  // @@
        label = "";
      }
      var altZone = mWiBottom.getAltZoneInfo();
      var maxZone = mWiBottom.getMaxZoneInfo();
      mWD.drawBottomInfoBG(label, value, units, zone, altZone, maxZone);
    }
    function drawBottomInfoFG(dc) {
      if (mWiBottom == null) {
        return;
      }
      var value = mWiBottom.getFormattedValue();
      var zone = mWiBottom.getZoneInfo();
      var units = mWiBottom.getUnits();

      var label = zone.name;
      if (mWiBottom.isLabelHidden()) {  // @@
        label = "";
      }
      var altZone = mWiBottom.getAltZoneInfo();
      var maxZone = mWiBottom.getMaxZoneInfo();
      mWD.drawBottomInfoFG(label, value, units, zone, altZone, maxZone);
    }
  }
}