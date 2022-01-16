import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Activity;
import Toybox.System;

using WhatAppBase.Utils as Utils;
import Toybox.Attention;
import Toybox.Time;
// Hit
// Start when enabled and x seconds power >= % of target -> show start counter / beep
// Property hit started
// Stop when enabled and x seconds power <= % of target -> show stop counter / beep
// Calc vo2 max approx + add hit counter

module WhatAppBase {
  class WhatAppHit {
    
    enum HitStatus { InActive = 0, WarmingUp = 1, CoolingDown = 2, Active = 3  }     

    hidden var hitEnabled as Boolean = false;
    hidden var hitPerformed as Number = 0;
    hidden var hitStatus as HitStatus = InActive;
    hidden var hitStartOnPerc as Number = 150; 
    hidden var hitStartCountDownSeconds as Number = 5; // @@ settings
    hidden var hitStopOnPerc as Number = 100; 
    hidden var hitStopCountDownSeconds as Number = 10; // @@ settings
    hidden var hitCounter as Number = 0;
    hidden var hitElapsedTime as Time.Moment?;
    hidden var hitElapsedRecoveryTime as Time.Moment?;

    hidden var minimalElapsedSeconds as Number = 30;
    hidden var minimalRecoverySeconds as Number = 300;

    hidden var hasSpeed as Boolean = false;    
    hidden var currentSpeed as Float = 0.0f;
    hidden var hasCadence as Boolean = false;
    hidden var currentCadence as Number = 0;
    hidden var activityPaused as Boolean = false;

    hidden var stoppingCountDownSeconds as Number = 5;
    hidden var stoppingTime as Time.Moment?;

    function initialize() {}

    // function setFtp(ftp as Number) as Void { self.ftp = ftp; }
    function setEnabled(hitEnabled as Boolean) as Void { self.hitEnabled = hitEnabled; }

    function setStartOnPerc(hitStartOnPerc as Number) as Void { self.hitStartOnPerc = hitStartOnPerc; }
    function setStopOnPerc(hitStartOnPerc as Number) as Void { self.hitStopOnPerc = hitStopOnPerc; }

    function isEnabled() as Boolean { return hitEnabled; }

    function monitorHit(info as Activity.Info, percOfTarget as Numeric) as Void {
      if (!hitEnabled) { return; }
      
      updateMetrics(info);
      updateRecoveryTime();     
     
      System.println(percOfTarget);

      switch (hitStatus) {
        case InActive:
          System.println("InActive");
          if (percOfTarget >= hitStartOnPerc) {
            // Start warming up for x seconds
            hitStatus = WarmingUp;  
            hitCounter = hitStartCountDownSeconds;            
          }
        break;
        case WarmingUp:
          System.println("Warming up");
          hitCounter = hitCounter - 1;
          hitAttentionWarmingUp();

          if (percOfTarget < hitStartOnPerc) {
            // Stop warming up
            hitStatus = InActive;       
            hitCounter = 0;       
          }     
          else {
            if (hitCounter == 0) {
              // End of warming up, start HIT
              hitStatus = Active;
              hitElapsedTime = Time.now();
              hitElapsedRecoveryTime = null;
              hitAttentionStart();
            }
          }
        break;
        case CoolingDown:
          System.println("Cooling down");
          hitCounter = hitCounter - 1;
          hitAttentionCoolingdown();
          
          if (percOfTarget >= hitStopOnPerc) {
            // Stop cooling down
            hitStatus = Active;  
            hitCounter = 0;
          } else {      
            if (hitCounter == 0) {
              hitStatus = InActive;
              hitAttentionStop();
              
              if ((getHitElapsedSeconds() - hitStopCountDownSeconds) >= minimalElapsedSeconds) { 
                // Proper HIT :-) @@Check FTP 
                hitPerformed = hitPerformed + 1;
                hitElapsedRecoveryTime = Time.now();
              } else {
                // No proper HIT 
                hitStatus = InActive;       
                hitCounter = 0;  
                hitElapsedRecoveryTime = null;
              }
              hitElapsedTime = null;
            }
          }
        break;
        case Active:
          System.println("Active");
          if (percOfTarget < hitStopOnPerc) {
            hitStatus = CoolingDown;  
            hitCounter = hitStopCountDownSeconds;
          }  
        break;
      }

     }     
    
    function updateRecoveryTime() as Void {
      if (hitElapsedRecoveryTime == null) { return; }
      if (!stopping()) { 
        stoppingTime = null;
        return; 
      }
      if (stoppingTime == null) { stoppingTime = Time.now(); }
      var seconds = Time.now().value() - (stoppingTime as Time.Moment).value();
      if (seconds >= stoppingCountDownSeconds) { hitElapsedRecoveryTime = null; }
    }

    function updateMetrics(info as Activity.Info) as Void {
      if (info has :currentSpeed) {        
        if (info.currentSpeed != null) {
          currentSpeed = info.currentSpeed as Float;
        } else {
          currentSpeed = 0.0f;
        }
        if (currentSpeed > 0 ) { hasSpeed = true; }
      }

      if (info has :currentCadence) {
        if (info.currentCadence != null) {
          currentCadence = info.currentCadence as Number;
        } else {
          currentCadence = 0;
        }
        if (currentCadence > 0 ) { hasCadence = true; }         
      }

      if (info has :timerState) {
        activityPaused =  info.timerState == Activity.TIMER_STATE_PAUSED;
      } else {
        activityPaused = false;
      }
    }

    function stopping() as Boolean {
      return activityPaused || (hasSpeed && currentSpeed == 0.0f) || (hasCadence && currentCadence == 0);
    }

    function hitAttentionWarmingUp() as Void {
      if (Attention has :playTone) {
        Attention.playTone(Attention.TONE_LOUD_BEEP);
      }
    } 

    function hitAttentionCoolingdown() as Void {
      if (Attention has :playTone) {
        Attention.playTone(Attention.TONE_LOUD_BEEP);
      }
    } 

    function hitAttentionStart() as Void {
      if (Attention has :playTone) {
        Attention.playTone(Attention.TONE_ALERT_HI);
      }
    } 

    function hitAttentionStop() as Void {
      if (Attention has :playTone) {
        Attention.playTone(Attention.TONE_ALERT_LO);
      }
    } 

    function getHitElapsedSeconds() as Number {
      // @@ Warn if greater than 60 seconds
      if (hitElapsedTime == null) { return 0; }
      return Time.now().value() - (hitElapsedTime as Time.Moment).value();
    }

    // Count down to 0
    function getRecoveryElapsedSeconds() as Number {
      // @@ Stop if greater than 6 minutes , Setting
      if (hitElapsedRecoveryTime == null) { return 0; }
      var seconds = Time.now().value() - (hitElapsedRecoveryTime as Time.Moment).value();
      var leftOver = minimalRecoverySeconds - seconds;
      if (leftOver < 0) { 
        hitElapsedRecoveryTime = null;
        return 0; 
      } 
      return leftOver;
    }

    function getNumberOfHits() as Number {
      return hitPerformed;
    }

    function getCounter() as Number {
      return hitCounter;
    }

    // @@ settings, no sound
    // @@ countdown on display (progressbar) -> or integrated in circle of FTP/Speed ..

  //
  }
}