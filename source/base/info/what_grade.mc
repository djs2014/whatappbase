import Toybox.Lang;
import Toybox.System;
import Toybox.Activity;
import Toybox.Graphics;

module WhatAppBase {
  class WhatGrade extends WhatInfoBase {
    hidden var previousAltitude as Float = 0.0f;
    hidden var currentAltitude as Float = 0.0f;
    hidden var previousElapsedDistance as Float = 0.0f;
    hidden var elapsedDistance as Float = 0.0f;
    hidden var grade as Double = 0.0d;  // %
    hidden var targetGrade as Number = 8;  // %

    hidden var gradeWindowSize as Number = 4;
    hidden var arrGrade as Array = [];
    hidden var gradeCutoff as Number = 100;

    // @@ settings
    hidden var minimalDistance as Float = 0.0f; // meter
    hidden var minimalAltitudeDiff as Float = 0.0f; // meter


    function initialize() { WhatInfoBase.initialize(); }

    function setTargetGrade(grade as Number) as Void { self.targetGrade = grade; }
    function setGradeWindow(size as Number) as Void { self.gradeWindowSize = size; }

    function updateInfo(info as Activity.Info) {
      var runOk = false;
      var riseOk = false;
      var rise = 0.0f;

      if (info has :altitude) {
        var tmpPreviousAltitude = currentAltitude;
        var tmpCurrentAltitude = 0.0f;
        if (info.altitude != null) {
          tmpCurrentAltitude = info.altitude as Float;
        } 
        System.println("CurrentAltitude: " + tmpCurrentAltitude);
        var tmpRise = tmpCurrentAltitude - tmpPreviousAltitude;
        if (Utils.abs(tmpRise) > minimalAltitudeDiff) {
          runOk = true;
          rise = tmpRise;
          
          currentAltitude = tmpCurrentAltitude;
          previousAltitude = currentAltitude;
          
          System.println("Rise: " + rise);
        }
      }
    
      var run = 0.0f;
      if (info has :elapsedDistance) {
        var tmpPreviousElapsedDistance = elapsedDistance;
        var tmpElapsedDistance = 0.0f;
        if (info.elapsedDistance != null) { tmpElapsedDistance = info.elapsedDistance as Float; } 
        run = tmpElapsedDistance - tmpPreviousElapsedDistance;
        if (run > minimalDistance) {
          riseOk = true;
          elapsedDistance = tmpElapsedDistance;
          previousElapsedDistance = tmpPreviousElapsedDistance;
          System.println("Run (distance): " + run );
        }
      }

      var tmpGrade = 0.0f;
      if (runOk || riseOk) {                    
          if (run != 0.0) {
            tmpGrade = (rise.toFloat() / run.toFloat()) * 100.0;
            System.println("tmpGrade: " + tmpGrade);         
          }
      }
      
      System.println(arrGrade);
      var skip = Utils.abs(tmpGrade) > gradeCutoff;

      if (skip || (arrGrade.size() == 0 && tmpGrade == 0 && grade == 0)) { 
        // No need to add 0 if already 0 
      } else if (runOk || riseOk) {

        if (((tmpGrade >=0 && grade < 0) || (tmpGrade < 0 && grade >= 0)) && arrGrade.size() > 1) {
          // Reset array - only last element remains
          arrGrade = arrGrade.slice(-1, null); 
        }  
        
        arrGrade.add(tmpGrade);
        if (arrGrade.size() > gradeWindowSize) {
            arrGrade = arrGrade.slice(1, null);
        }
        grade = Math.mean(arrGrade as Array<Float>);
        if (grade == 0) { arrGrade = []; }
        System.println("grade: " + grade);
      }
      
    }

    function getZoneInfo() as ZoneInfo { return _getZoneInfo(getGrade()); }
    function getValue() as WhatValue { return getGrade(); }
    function getFormattedValue() as String { return getGrade().format("%.1f"); }
    function getUnits() as String { return "%"; }
    function getLabel() as String { return "Grade"; }

    // --
    hidden function getCurrentAltitude() as Float {
      if (currentAltitude == null) {
        return 0.0f;
      }
      return self.currentAltitude;
    }

    hidden function getCurrentDistance() as Float {
      if (elapsedDistance == null) {
        return 0.0f;
      }
      return self.elapsedDistance;
    }

    hidden function getGrade() as Double {
      if (grade == null) {
        return 0.0d;
      }
      return grade;
    }

    hidden function _getZoneInfo(grade as Double) as ZoneInfo {
      if (grade == null || grade == 0) {
        return new ZoneInfo(0, "Grade", Graphics.COLOR_WHITE,
                            Graphics.COLOR_BLACK, 0, null);
      }
      //var color = getGradeColor(grade);
      
      var percOfTarget = Utils.percentageOf(Utils.abs(grade), targetGrade);
      var color = percentageToColor(percOfTarget);
      var color100perc = null;
      if (percOfTarget > 100) {
        color100perc = percentageToColor(100);
      }

      return new ZoneInfo(0, "Grade", color, Graphics.COLOR_BLACK, percOfTarget, color100perc);
    }
    
  }
}