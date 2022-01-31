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
    enum HitMode { HitDisabled = 0, HitMinimal = 1, HitNormal = 2  }     
    enum HitSound { NoSound = 0, StartOnlySound = 1, LowNoise = 2, LoudNoise = 3  }     

    hidden var hitMode as HitMode = HitDisabled;
    hidden var hitSound as HitSound = LowNoise;
    hidden var soundEnabled as Boolean = false;
    
    hidden var hitPaused as Boolean = false;
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

    hidden var wVo2Max as WhatVo2Max?;
    hidden var calcVo2Max as Boolean = false;
    hidden var playTone as Boolean = true;

    hidden var hitScores as Array = []; //[50.5,30.5,60.4,50.4,60.4]; // @@ TEST
    hidden var hitDurations as Array = []; //[30,31,30,35,40]; // @@ TEST
    hidden var currentDuration as Number = 0;
    hidden var currentScore as Float = 0.0f;

    function initialize() {}

    function setMode(hitMode as HitMode) as Void { self.hitMode = hitMode; }
    function setSound(hitSound as HitSound) as Void { 
      self.hitSound = hitSound;
      soundEnabled = (self.hitSound as HitSound) != NoSound;
    }
        
    function setPaused(hitPaused as Boolean) as Void { self.hitPaused = hitPaused; }

    function setStartOnPerc(hitStartOnPerc as Number) as Void { self.hitStartOnPerc = hitStartOnPerc; }
    function setStopOnPerc(hitStartOnPerc as Number) as Void { self.hitStopOnPerc = hitStopOnPerc; }
    function setStartCountDownSeconds(hitStartCountDownSeconds as Number) as Void { self.hitStartCountDownSeconds = hitStartCountDownSeconds; }
    function setStopCountDownSeconds(hitStopCountDownSeconds as Number) as Void { self.hitStopCountDownSeconds = hitStopCountDownSeconds; }

    function isEnabled() as Boolean { return (self.hitMode as HitMode) != HitDisabled; }
    function isMinimal() as Boolean { return (self.hitMode as HitMode) == HitMinimal; }
    function isActivityPaused() as Boolean { return activityPaused; }
    
    function getHitScores() as Array { return hitScores; }
    function getHitDurations() as Array { return hitDurations; }

    function monitorHit(info as Activity.Info, percOfTarget as Numeric) as Void {
      if (!isEnabled()) { return; }
            
      calcVo2Max = ((hitStatus as HitStatus)== Active);
      updateMetrics(info);
      updateRecoveryTime();     
      if (activityPaused || hitPaused) {
        hitStatus = InActive;
        hitCounter = 0;  
        hitElapsedRecoveryTime = null;
        hitElapsedTime = null;
        playTone = soundEnabled;  
        return;
      }
      //System.println(percOfTarget);

      switch (hitStatus) {
        case InActive:
          System.println("InActive");
          if (percOfTarget >= hitStartOnPerc) {
            // Start warming up for x seconds
            hitStatus = WarmingUp;  
            hitCounter = hitStartCountDownSeconds; 
            playTone = soundEnabled;           
          }
        break;
        case WarmingUp:
          System.println("Warming up");
          hitCounter = hitCounter - 1;
          hitAttentionWarmingUp(playTone);

          if (percOfTarget < hitStartOnPerc) {
            // Stop warming up
            hitStatus = InActive;       
            hitCounter = 0;       
          }     
          else {
            if (hitCounter == 0) {
              // End of warming up, start HIT
              if ( wVo2Max!= null) { (wVo2Max as WhatVo2Max).clearData(); }              
              hitStatus = Active;
              hitElapsedRecoveryTime = null;
              currentDuration = 0;
              currentScore = 0.0f;
              hitElapsedTime = Time.now();
              hitAttentionStart();              
            }
          }
        break;
        case CoolingDown:
          System.println("Cooling down");
          hitAttentionCoolingdown(playTone);
          hitCounter = hitCounter - 1;
          
          if (percOfTarget >= hitStopOnPerc) {
            // Stop cooling down
            hitStatus = Active;  
            hitCounter = 0;
          } else {      
            if (hitCounter == 0) {
              hitStatus = InActive;
              
              if (currentDuration >= minimalElapsedSeconds) { 
                hitAttentionStop();
                // Proper HIT :-) 
                hitPerformed = hitPerformed + 1;
                hitElapsedRecoveryTime = Time.now();  
                hitScores.add(currentScore);
                hitDurations.add(currentDuration);
              } else {
                // No proper HIT (no sound)
                hitStatus = InActive;       
                hitCounter = 0;  
                hitElapsedRecoveryTime = null;  
                currentScore = 0.0f;
                currentDuration = 0;              
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
            hitAttentionWarn();
            // only sound when proper hit
            playTone = soundEnabled && (getHitElapsedSeconds() >= minimalElapsedSeconds);  
            currentDuration = getHitElapsedSeconds();
            currentScore = getVo2Max();              
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

      if (wVo2Max == null) {
        wVo2Max = new WhatVo2Max();
        (wVo2Max as WhatVo2Max).initWeight();       
      }
      if (calcVo2Max) {
        (wVo2Max as WhatVo2Max).updateInfo(info);
      }

    }

    function stopping() as Boolean {
      return activityPaused || (hasSpeed && currentSpeed == 0.0f) || (hasCadence && currentCadence == 0);
    }

    function hitAttentionWarmingUp(playTone as Boolean) as Void {
      if (Attention has :playTone && soundEnabled && playTone ) {
        if (Attention has :ToneProfile) {
          var toneProfileBeeps = [ new Attention.ToneProfile( 1500, 50) ] as Lang.Array<Attention.ToneProfile>;
          Attention.playTone({:toneProfile=>toneProfileBeeps});
        } else {
          Attention.playTone(Attention.TONE_LOUD_BEEP);
        }
      }
    } 

    function hitAttentionCoolingdown(playTone as Boolean) as Void {
      if (Attention has :playTone && soundEnabled && playTone && (hitSound != StartOnlySound)) {
        if (Attention has :ToneProfile && (hitSound == LowNoise)) { 
          var toneProfileBeeps = [ new Attention.ToneProfile( 1000, 50) ] as Lang.Array<Attention.ToneProfile>;      
          Attention.playTone({:toneProfile=>toneProfileBeeps});
        } else {
          Attention.playTone(Attention.TONE_LOUD_BEEP);
        }     
      }
    } 

    function hitAttentionWarn() as Void {
      if (Attention has :playTone && soundEnabled) {
       if (Attention has :ToneProfile) { 
          var toneProfileBeeps = [ 
            new Attention.ToneProfile( 1000, 40),
            new Attention.ToneProfile( 1500, 100),
          ] as Lang.Array<Attention.ToneProfile>;      
          Attention.playTone({:toneProfile=>toneProfileBeeps});
        }  
      }
    } 

    function hitAttentionStart() as Void {
      if (Attention has :playTone && soundEnabled) {
        if (Attention has :ToneProfile && (hitSound == LowNoise)) { 
          var toneProfileBeeps = [ new Attention.ToneProfile( 1100, 150) ] as Lang.Array<Attention.ToneProfile>;      
          Attention.playTone({:toneProfile=>toneProfileBeeps});
        } else {
          Attention.playTone(Attention.TONE_ALERT_HI);        
        }
      }
    } 

    function hitAttentionStop() as Void {
      if (Attention has :playTone && soundEnabled && (hitSound != StartOnlySound)) {
        if (Attention has :ToneProfile && (hitSound == LowNoise)) {            
            var toneProfileBeeps = [ 
              new Attention.ToneProfile( 1100, 100), 
              new Attention.ToneProfile( 800, 80), 
              new Attention.ToneProfile( 500, 30) 
              ] as Lang.Array<Attention.ToneProfile>;
            Attention.playTone({:toneProfile=>toneProfileBeeps});
        } else {
          Attention.playTone(Attention.TONE_ALERT_LO);
        }
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

    function getVo2Max() as Float {
      if (wVo2Max == null) { return 0.0f; }
      return (wVo2Max as WhatVo2Max).getValue();
    }
    
    // @@ settings, no sound
    // @@ countdown on display (progressbar) -> or integrated in circle of FTP/Speed ..

  //
  }
}