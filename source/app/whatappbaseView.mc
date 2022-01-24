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
      // @@ TODO hit.setPaused(mWD.isHiddenField());

      // @@ Nice to have transparent text (rgba)
      var counter = hit.getCounter();      
      if (counter > 0 ) {
        var countdown = counter.format("%01d");
        dc.setColor(Graphics.COLOR_DK_RED, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth()/2, dc.getHeight()/2, Graphics.FONT_SYSTEM_NUMBER_THAI_HOT, countdown, 
          Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
      } else {
        var hitElapsed = hit.getHitElapsedSeconds();
        if (hitElapsed > 0) {

          var yHeight = dc.getFontHeight(Graphics.FONT_SYSTEM_NUMBER_HOT);
          if(mWD.isLargeField()) {            
            var vo2max = hit.getVo2Max();
            if (vo2max > 7) {
              var vo2mText = vo2max.format("%0.1f");
              var yHeightVo2 = dc.getFontHeight(Graphics.FONT_SYSTEM_NUMBER_MILD);
              dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
              dc.drawText(dc.getWidth()/2, dc.getHeight()/2 - yHeightVo2/3, Graphics.FONT_SYSTEM_NUMBER_MILD, vo2mText, 
                Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);                                
            }
          } else {
            yHeight = 0;
          }

          var elapsed = Utils.secondsToCompactTimeString(hitElapsed, "{m}:{s}");
          dc.setColor(Graphics.COLOR_ORANGE, Graphics.COLOR_TRANSPARENT);          
          dc.drawText(dc.getWidth()/2, dc.getHeight()/2 + yHeight/2, Graphics.FONT_SYSTEM_NUMBER_HOT, elapsed,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);        
        }
      }

      var fontHitInfo = Graphics.FONT_SYSTEM_XTINY;
      if (mWD.isLargeField()) { fontHitInfo = Graphics.FONT_SYSTEM_TINY; }

      var offset = 0;
      if (hit.isActivityPaused() && mWD.isLargeField()) { offset = 3; }
      var x = 1 + offset;
      var yHitInfo = dc.getHeight() - dc.getFontHeight(fontHitInfo) - offset;
      var hitInfo = "H";
      var hitPerformed = hit.getNumberOfHits();
      if (hitPerformed > 0) { hitInfo = hitInfo + hitPerformed.format("%01d"); }    
      var hitRecovery = hit.getRecoveryElapsedSeconds();

      if (hitPerformed > 0 || hitRecovery > 0 ) {
        var wHitInfo = dc.getTextWidthInPixels(hitInfo, fontHitInfo);
        dc.setColor(Graphics.COLOR_DK_GREEN, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, yHitInfo, fontHitInfo, hitInfo, Graphics.TEXT_JUSTIFY_LEFT);        
        x = x + wHitInfo + 1;

        var scores = hit.getHitScores();
        var startIdxOnlyLast = Utils.max(0, scores.size() - 3);        
        for (var sIdx = startIdxOnlyLast; sIdx < scores.size(); sIdx++) {  
          var score = scores[sIdx] as Float;              
          //var scoreText = score.format("%0.1f");
          var scoreText = score.format("%0.0f");
          var wScoreText = dc.getTextWidthInPixels(scoreText, fontHitInfo);
          dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
          dc.drawText(x, yHitInfo, fontHitInfo, scoreText, Graphics.TEXT_JUSTIFY_LEFT);              
          x = x + wScoreText + 3;          
        }

        if (hitRecovery > 0) {
          var recovery = Utils.secondsToCompactTimeString(hitRecovery, "({m}:{s})");   
          dc.setColor(Graphics.COLOR_DK_GREEN, Graphics.COLOR_TRANSPARENT);
          dc.drawText(dc.getWidth(), yHitInfo, fontHitInfo, recovery, Graphics.TEXT_JUSTIFY_RIGHT);     
        }
      } 

      if (hitRecovery == 0) {
        var vo2m = hit.getVo2Max();
        if (vo2m > 7) {
          var vo2mT = "(" + vo2m.format("%0.0f") + ")";
          dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
          dc.drawText(dc.getWidth(), yHitInfo, fontHitInfo, vo2mT, Graphics.TEXT_JUSTIFY_RIGHT);     
        }
      }
      // @@ TODO 
      // if (hit.isActivityPaused() && hitPerformed > 0) {
      //   // @@ Display hit scores
      //   var scores = hit.getHitScores();
      //   var total = scores.size();
      //   var w = dc.getWidth() - based on duraction
      // 
      //   for (var x = 0; x < scores.size(); x++) {
      //     var 
      //     ppx = ppx + perSec[x];
      //   }
      // }      
    }
    
  }
}