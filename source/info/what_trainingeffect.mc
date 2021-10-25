module WhatAppBase {import Toybox.Lang;
import Toybox.System;
import Toybox.Activity;

class WhatTrainingEffect extends WhatBase {
  hidden var trainingEffect = 0;
  hidden var targetEffect = 4.8f;

  function initialize() { WhatBase.initialize(); }

  function updateInfo(info as Activity.Info) {
    available = false;
    if (info has : trainingEffect) {
      if (info.trainingEffect) {
        trainingEffect = info.trainingEffect;
      } else {
        trainingEffect = 0.0f;
      }
      // Training effect needs HR data
      if (info has : currentHeartRate) {
        if (info.currentHeartRate) {
          available = true;
        } 
      }
    }
  }

  function getTrainingEffect() {
    if (trainingEffect == null) {
      return 0;
    }
    return self.trainingEffect;
  }

  function getUnitsLong() as String { return "te"; }

  function getUnits() as String { return "te"; }

  function getFormatString(fieldType) as String { return "%.1f"; }

  //
  function getZoneInfo(effect) {    
    if (effect == null || effect == 0) {
      return new ZoneInfo(0, "Training effect", Graphics.COLOR_WHITE,
                          Graphics.COLOR_BLACK, 0, null);
    }

    var percOfTarget = percentageOf(effect, targetEffect);

    if (effect < 1) {
      return new ZoneInfo(1, "No effect", WhatColor.COLOR_WHITE_BLUE_3,
                          Graphics.COLOR_BLACK, percOfTarget, null);
    }
    if (effect < 2) {
      return new ZoneInfo(2, "Minor effect", WhatColor.COLOR_WHITE_LT_GREEN_3,
                          Graphics.COLOR_BLACK, percOfTarget, null);
    }
    if (effect < 3) {
      return new ZoneInfo(3, "Maintaining", WhatColor.COLOR_WHITE_YELLOW_3,
                          Graphics.COLOR_BLACK, percOfTarget, null);
    }
    if (effect < 4) { // Improving
      return new ZoneInfo(3, "Highly improving", WhatColor.COLOR_WHITE_ORANGE_3,
                          Graphics.COLOR_BLACK, percOfTarget, null);
    }
    if (effect < 5) {
      var color = WhatColor.COLOR_WHITE_ORANGERED_3;
      if (effect > 4.8) {
        color = WhatColor.COLOR_WHITE_ORANGERED2_3;
      }
      return new ZoneInfo(4, "Highly improving", color, Graphics.COLOR_BLACK,
                          percOfTarget, null);
    }
    return new ZoneInfo(5, "Overloading ", WhatColor.COLOR_WHITE_RED_3,
                        Graphics.COLOR_BLACK, percOfTarget, null);
  }
}}