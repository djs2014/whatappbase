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
    
    hidden var mHit as WhatAppHit?;

    hidden var mWiTop as WhatInformation?;
    hidden var mWiLeft as WhatInformation?;
    hidden var mWiRight as WhatInformation?;
    hidden var mWiBottom as WhatInformation?;

    function initialize(whatApp as WhatApp) {
      DataField.initialize();
      mApp = whatApp;
      mFactory = mApp.mFactory;
      mHit = mApp.mHit;      
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

      processHit(info);

      mShowAppName = true;
      if (info has : timerState) {
        mShowAppName = (info.timerState != Activity.TIMER_STATE_ON);
      }
    }

    function processHit(info as Activity.Info) as Void {
      var hit = mHit as WhatAppHit;
      if (!hit.isEnabled()) { return;}
      
      var wP = mFactory.getPowerInstance();
      if (wP == null) {
        hit.setEnabled(false);
        return;
      }
      
      var pot = (wP as WhatPower).getPercOfTarget();      
      hit.monitorHit(info, pot);
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

      drawHit(dc);
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

    function drawHit(dc as Dc) as Void {
      var hit = mHit as WhatAppHit;
      if (!hit.isEnabled()) { return;}
      

      // @@ Nice to have transparent text (rgba)
      var showVo2Max = false;
      var counter = hit.getCounter();      
      if (counter > 0 ) {
        showVo2Max = true;
        var countdown = counter.format("%01d");
        dc.setColor(Graphics.COLOR_DK_RED, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth()/2, dc.getHeight()/2, Graphics.FONT_SYSTEM_NUMBER_THAI_HOT, countdown, Graphics.TEXT_JUSTIFY_CENTER| Graphics.TEXT_JUSTIFY_VCENTER);
      } else {
        var hitElapsed = hit.getHitElapsedSeconds();
        if (hitElapsed > 0) {
          showVo2Max = true;
          var elapsed = Utils.secondsToCompactTimeString(hitElapsed, "{m}:{s}");
          dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
          var yOf = dc.getHeight() / 8;
          dc.drawText(dc.getWidth()/2, dc.getHeight()/2 + yOf, Graphics.FONT_SYSTEM_NUMBER_HOT, elapsed, Graphics.TEXT_JUSTIFY_CENTER| Graphics.TEXT_JUSTIFY_VCENTER);        
        }
      }

      var fontLabel = Graphics.FONT_SMALL;
      var font = Graphics.FONT_MEDIUM;
      var x = 1;
      var yLabel = dc.getHeight() - dc.getFontHeight(fontLabel);
      var y = dc.getHeight() - dc.getFontHeight(font);
      var text = "H";
      var hitPerformed = hit.getNumberOfHits();
      if (hitPerformed > 0) { text = text + hitPerformed.format("%01d"); }
    
      var wText = dc.getTextWidthInPixels(text, fontLabel);
      var hitRecovery = hit.getRecoveryElapsedSeconds();

      if (hitPerformed > 0 || hitRecovery > 0 ) {
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, yLabel, fontLabel, text, Graphics.TEXT_JUSTIFY_LEFT);
        if (hitRecovery > 0) {
          showVo2Max = true;
          text = Utils.secondsToCompactTimeString(hitRecovery, "{m}:{s}");   
          dc.drawText(x + wText + 1, y, font, text, Graphics.TEXT_JUSTIFY_LEFT);     
        }
      }

      // @@ small label
      //if (showVo2Max) {
        var vo2mText = hit.getVo2Max().format("%0.1f");
        var wVo2mText = dc.getTextWidthInPixels(vo2mText, font);
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth(), y, font, vo2mText, Graphics.TEXT_JUSTIFY_RIGHT);
        dc.drawText(dc.getWidth() - wVo2mText + 1, yLabel, fontLabel, "vO2:", Graphics.TEXT_JUSTIFY_RIGHT);
      //}
    }
  }
}