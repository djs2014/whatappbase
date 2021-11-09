module WhatAppBase {
import Toybox.Lang;
import Toybox.System;
import Toybox.Activity;

  class WhatInformation {
    var objInstance = null;

    // Update instance with latest activity data
    var methodUpdateInfo = null;

    // Get current zone info for value
    var methodGetZoneInfo = null;
    var methodGetValue = null;
    var methodGetFormattedValue = null;
    var methodGetUnits = null;
    var methodGetLabel = null;

    // Get current zone info for alternative value (ex. for average value)
    var methodGetAltZoneInfo = null;
    var methodGetAltValue = null;
    var methodGetAltFormattedValue = null;
    var methodGetAltUnits = null;
    var methodGetAltLabel = null;

    var methodGetMaxZoneInfo = null;
    var methodGetMaxValue = null;

    var methodIsLabelHidden = null;  // @@ via methodGetLabel?

    function initialize(objInstance as WhatInfoBase) {
      self.objInstance = objInstance;
      // defaults

      methodUpdateInfo = new Lang.Method(self.objInstance, : updateInfo);

      methodGetZoneInfo = new Lang.Method(self.objInstance, : getZoneInfo);
      methodGetValue = new Lang.Method(self.objInstance, : getValue);
      methodGetFormattedValue = new Lang.Method(self.objInstance,
                                                : getFormattedValue);
      methodGetUnits = new Lang.Method(self.objInstance, : getUnits);
      methodGetLabel = new Lang.Method(self.objInstance, : getLabel);

      methodGetAltZoneInfo = new Lang.Method(self.objInstance,
                                             : getAltZoneInfo);
      methodGetAltValue = new Lang.Method(self.objInstance, : getAltValue);
      methodGetAltFormattedValue = new Lang.Method(self.objInstance,
                                                   : getAltFormattedValue);
      methodGetAltUnits = new Lang.Method(self.objInstance, : getAltUnits);
      methodGetAltLabel = new Lang.Method(self.objInstance, : getAltLabel);

      methodGetMaxZoneInfo = new Lang.Method(self.objInstance,
                                             : getMaxZoneInfo);
      methodGetMaxValue = new Lang.Method(self.objInstance, : getMaxValue);
      // @@
      methodIsLabelHidden = new Lang.Method(self.objInstance, : isLabelHidden);
    }

    function getObject() as WhatInfoBase { return objInstance; }
    function updateInfo(info as Activity.Info) {
      return methodUpdateInfo.invoke(info);
    }

    // @@
    function isLabelHidden() as Lang.Boolean {
      return methodIsLabelHidden.invoke();
    }

    function getZoneInfo() as ZoneInfo { return methodGetZoneInfo.invoke(); }
    function getValue() { return methodGetValue.invoke(); }
    function getFormattedValue() as Lang.String {
      return methodGetFormattedValue.invoke();
    }
    function getUnits() as String { return methodGetUnits.invoke(); }
    function getLabel() as String { return methodGetLabel.invoke(); }

    function getAltZoneInfo() as ZoneInfo {
      return methodGetAltZoneInfo.invoke();
    }
    function getAltValue() { return methodGetAltValue.invoke(); }
    function getAltFormattedValue() as Lang.String {
      return methodGetAltFormattedValue.invoke();
    }
    function getAltUnits() as String { return methodGetAltUnits.invoke(); }
    function getAltLabel() as String { return methodGetAltLabel.invoke(); }

    function getMaxZoneInfo() as ZoneInfo {
      return methodGetMaxZoneInfo.invoke();
    }
    function getMaxValue() { return methodGetMaxValue.invoke(); }

    function setCallback(callbackMethod, callback) as Void {
      switch (callbackMethod) {
        case cbZoneInfo:
          methodGetZoneInfo = new Lang.Method(self.objInstance, callback);
          break;
        case cbValue:
          methodGetValue = new Lang.Method(self.objInstance, callback);
          break;
        case cbFormattedValue:
          methodGetFormattedValue = new Lang.Method(self.objInstance, callback);
          break;
        case cbUnits:
          methodGetUnits = new Lang.Method(self.objInstance, callback);
          break;
        case cbLabel:
          methodGetLabel = new Lang.Method(self.objInstance, callback);
          break;
        case cbAltZoneInfo:
          methodGetAltZoneInfo = new Lang.Method(self.objInstance, callback);
          break;
        case cbAltValue:
          methodGetAltValue = new Lang.Method(self.objInstance, callback);
          break;
        case cbAltFormattedValue:
          methodGetAltFormattedValue =
              new Lang.Method(self.objInstance, callback);
          break;
        case cbAltUnits:
          methodGetAltUnits = new Lang.Method(self.objInstance, callback);
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

enum {
  cbZoneInfo,
  cbValue,
  cbFormattedValue,
  cbUnits,
  cbLabel,
  cbAltZoneInfo,
  cbAltValue,
  cbAltFormattedValue,
  cbAltUnits,
  cbAltLabel
}