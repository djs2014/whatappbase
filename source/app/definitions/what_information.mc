module WhatAppBase {
import Toybox.Lang;
import Toybox.System;
import Toybox.Activity;

  class WhatInformation {
    var objInstance as Object?;

    // Update instance with latest activity data
    var methodUpdateInfo as Method;

    // Get current zone info for value
    var methodGetZoneInfo as Method;
    // var methodGetValue as Method;
    var methodGetFormattedValue as Method;
    var methodGetUnits as Method;
    var methodGetInfo as Method;
    var methodGetLabel as Method;

    // Get current zone info for alternative value (ex. for average value)
    var methodGetAltZoneInfo as Method;
    // var methodGetAltValue as Method;
    var methodGetAltFormattedValue as Method;
    var methodGetAltUnits as Method;
    var methodGetAltInfo as Method;
    var methodGetAltLabel as Method;

    var methodGetMaxZoneInfo as Method;
    var methodGetMaxValue as Method;

    var methodIsLabelHidden as Method;  // @@ via methodGetLabel?

    function initialize(objInstance as WhatInfoBase) {
      self.objInstance = objInstance;
      // defaults

      methodUpdateInfo = new Lang.Method(self.objInstance, :updateInfo);

      methodGetZoneInfo = new Lang.Method(self.objInstance, :getZoneInfo);
      // methodGetValue = new Lang.Method(self.objInstance, :getValue);
      methodGetFormattedValue = new Lang.Method(self.objInstance, :getFormattedValue);
      methodGetUnits = new Lang.Method(self.objInstance, :getUnits);
      methodGetInfo = new Lang.Method(self.objInstance, :getInfo);
      methodGetLabel = new Lang.Method(self.objInstance, :getLabel);

      methodGetAltZoneInfo = new Lang.Method(self.objInstance, :getAltZoneInfo);
      // methodGetAltValue = new Lang.Method(self.objInstance, :getAltValue);
      methodGetAltFormattedValue = new Lang.Method(self.objInstance, :getAltFormattedValue);
      methodGetAltUnits = new Lang.Method(self.objInstance, :getAltUnits);
      methodGetAltInfo = new Lang.Method(self.objInstance, :getAltInfo);
      methodGetAltLabel = new Lang.Method(self.objInstance, :getAltLabel);

      methodGetMaxZoneInfo = new Lang.Method(self.objInstance, :getMaxZoneInfo);
      methodGetMaxValue = new Lang.Method(self.objInstance, :getMaxValue);
      // @@ TODO
      methodIsLabelHidden = new Lang.Method(self.objInstance, :isLabelHidden);
    }

    function getObject() as WhatInfoBase? { return objInstance; }
    function updateInfo(info as Activity.Info) as Void { methodUpdateInfo.invoke(info); }

    // @@ TODO
    function isLabelHidden() as Boolean {
      return methodIsLabelHidden.invoke();
    }

    function getZoneInfo() as ZoneInfo { return methodGetZoneInfo.invoke(); }
    // function getValue() as WhatValue { return methodGetValue.invoke(); }
    function getFormattedValue() as String { return methodGetFormattedValue.invoke(); }
    function getUnits() as String { return methodGetUnits.invoke(); }
    function getInfo() as String { return methodGetInfo.invoke(); }
    function getLabel() as String { return methodGetLabel.invoke(); }

    function getAltZoneInfo() as ZoneInfo { return methodGetAltZoneInfo.invoke(); }
    // function getAltValue() as WhatValue { return methodGetAltValue.invoke(); }
    function getAltFormattedValue() as String { return methodGetAltFormattedValue.invoke(); }
    function getAltUnits() as String { return methodGetAltUnits.invoke(); }
    function getAltInfo() as String { return methodGetAltInfo.invoke(); }
    function getAltLabel() as String { return methodGetAltLabel.invoke(); }

    function getMaxZoneInfo() as ZoneInfo { return methodGetMaxZoneInfo.invoke(); }
    function getMaxValue() as WhatValue { return methodGetMaxValue.invoke(); }

    function setCallback(callbackMethod as CallbackType, callback as Symbol) as Void {
      switch (callbackMethod) {
        case cbZoneInfo:
          methodGetZoneInfo = new Lang.Method(self.objInstance, callback);
          break;
        // case cbValue:
        //   methodGetValue = new Lang.Method(self.objInstance, callback);
        //   break;
        case cbFormattedValue:
          methodGetFormattedValue = new Lang.Method(self.objInstance, callback);
          break;
        case cbUnits:
          methodGetUnits = new Lang.Method(self.objInstance, callback);
          break;
        case cbInfo:
          methodGetInfo = new Lang.Method(self.objInstance, callback);
          break;  
        case cbLabel:
          methodGetLabel = new Lang.Method(self.objInstance, callback);
          break;
        case cbAltZoneInfo:
          methodGetAltZoneInfo = new Lang.Method(self.objInstance, callback);
          break;
        // case cbAltValue:
        //   methodGetAltValue = new Lang.Method(self.objInstance, callback);
        //   break;
        case cbAltFormattedValue:
          methodGetAltFormattedValue =
              new Lang.Method(self.objInstance, callback);
          break;
        case cbAltUnits:
          methodGetAltUnits = new Lang.Method(self.objInstance, callback);
          break;
        case cbAltInfo:
          methodGetAltInfo = new Lang.Method(self.objInstance, callback);
          break;    
        case cbAltLabel:
          methodGetAltLabel = new Lang.Method(self.objInstance, callback);
          break;
        default:
          System.println("Callback not defined: " + callbackMethod);
      }
    }
  }
}

enum CallbackType {
  cbZoneInfo,
  cbValue,
  cbFormattedValue,
  cbUnits,
  cbInfo,
  cbLabel,
  cbAltZoneInfo,
  cbAltValue,
  cbAltFormattedValue,
  cbAltUnits,
  cbAltInfo,
  cbAltLabel
}