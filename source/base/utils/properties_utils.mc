import Toybox.Lang;
import Toybox.Application;
import Toybox.System;
module WhatAppBase {
  (:Utils) 
  module Utils {

    function getApplicationProperty(key as Application.PropertyKeyType, dflt as Application.PropertyValueType ) as Application.PropertyValueType {
      try {
        var val = Toybox.Application.Properties.getValue(key);
        if (val != null) { return val; }
      } catch (e) {
        return dflt;
      }
      return dflt;
    }

    function getDictionaryValue(data as Dictionary, key as String, defaultValue as Numeric?) as Numeric? {
      var value = data.get(key);
      if (value == null) { return defaultValue; }
      return value as Numeric;
    }

    function setProperty(key as PropertyKeyType, value as PropertyValueType) as Void {
      Application.Properties.setValue(key, value);
    }
  }
}