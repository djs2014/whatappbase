import Toybox.Lang;
import Toybox.System;
import Toybox.Activity;
module WhatAppBase {
  class WhatTrainingEffect extends WhatInfoBase {
    hidden var trainingEffect = 0;
    hidden var targetEffect = 4.8f;

    function initialize() { WhatInfoBase.initialize(); }

    function updateInfo(info as Activity.Info) {
      mAvailable = false;
      if (info has : trainingEffect) {
        if (info.trainingEffect != null) {
          trainingEffect = info.trainingEffect;
        } else {
          trainingEffect = 0.0f;
        }
        // Training effect needs HR data
        if (info has : currentHeartRate) {
          if (info.currentHeartRate != null) {
            mAvailable = true;
          }
        }
      }
    }

    function getZoneInfo() as ZoneInfo {
      return _getZoneInfo(getTrainingEffect());
    }
    function getValue() { return getTrainingEffect(); }
    function getFormattedValue() as Lang.String {
      return getTrainingEffect().format("%.1f");
    }
    function getUnits() as String { return "te"; }
    function getLabel() as Lang.String { return "Training effect"; }

    // --
    hidden function getTrainingEffect() {
      if (trainingEffect == null) {
        return 0;
      }
      return self.trainingEffect;
    }
    
    hidden function _getZoneInfo(effect) {
      if (effect == null || effect == 0) {
        return new ZoneInfo(0, "Training effect", Graphics.COLOR_WHITE,
                            Graphics.COLOR_BLACK, 0, null);
      }

      var percOfTarget = Utils.percentageOf(effect, targetEffect);

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
      if (effect < 4) {  
        return new ZoneInfo(4, "Improving",
                            WhatColor.COLOR_WHITE_ORANGE_3,
                            Graphics.COLOR_BLACK, percOfTarget, null);
      }
      if (effect < 5) {
        var color = WhatColor.COLOR_WHITE_ORANGERED_3;
        if (effect > 4.8) {
          color = WhatColor.COLOR_WHITE_ORANGERED2_3;
        }
        return new ZoneInfo(5, "Highly improving", color, Graphics.COLOR_BLACK,
                            percOfTarget, null);
      }
      return new ZoneInfo(6, "Overloading ", WhatColor.COLOR_WHITE_RED_3,
                          Graphics.COLOR_BLACK, percOfTarget, null);
    }
  }
}