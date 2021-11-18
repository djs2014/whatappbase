import Toybox.Lang;
import Toybox.Application;
import Toybox.System;
module WhatAppBase {
  (:Utils) 
  module Utils {
    function getStringProperty(key as PropertyKeyType, dflt as Lang.String) as Lang.String {
      // Test.assert(dflt instanceof Lang.String);
      try {
        var val = Application.Properties.getValue(key as Lang.String) as Lang.String;
        if (val != null && val instanceof Lang.String && !"".equals(val)) {
          return val;
        }
      } catch (e) {
        return dflt;
      }
      return dflt;
    }

    function getBooleanProperty(key as PropertyKeyType, dflt as Boolean) as Boolean {
      return getTypedProperty(key, dflt, Lang.Boolean);
    }

    function getNumberProperty(key as PropertyKeyType, dflt as Lang.Number) as Lang.Number {
      return getTypedProperty(key, dflt, Lang.Number);   
    }

    function getFloatProperty(key as PropertyKeyType, dflt as Float) as Float {
      return getTypedProperty(key, dflt, Lang.Float);
    }

    function getLongProperty(key as PropertyKeyType, dflt as Long) as Long {
      return getTypedProperty(key, dflt, Lang.Long);
    }

    function getDoubleProperty(key as PropertyKeyType, dflt as Double) as Double {
      return getTypedProperty(key, dflt, Lang.Double);
    }

    function getTypedProperty(key as PropertyKeyType, dflt as PropertyValueType, keyType as PropertyKeyType) as PropertyValueType {
      try {
        var val = Application.Properties.getValue(key) as PropertyValueType;
        // @@ if (val != null && val instanceof keyType) {
        if (val != null) {  // because of strict
          return val;
        }
      } catch (e) {
        return dflt;
      }
      return dflt;
    }

    function setProperty(key as PropertyKeyType, value as PropertyValueType) as Void {
      Application.Properties.setValue(key, value);
    }
  }
}